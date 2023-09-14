import pyvista  as pv
import numpy as np
import pandas as pd
import pyacvd as pa
from numba import njit,jit
from scipy.special import comb, perm




def _repair_mesh(mesh,spin):
    """
    Repairs a mesh by removing duplicate points and faces, and removing unused points.

    Args:
    - mesh: a PyVista mesh object

    Returns:
    - mesh: a PyVista mesh object
    """
    # mesh = pv.read(mesh)
    points = mesh.points
    _faces = mesh.faces.reshape((-1,4))
    faces  = _faces[:,1:]
    bond = []
    for face in faces:
        bond.append([[face[0],face[1]]])
        bond.append([[face[1],face[2]]])
        bond.append([[face[2],face[0]]])
    bond = np.array(bond)
    bond = np.sort(bond,axis=1)
    bonds = np.unique(bond,axis=0)
    
    I_face = np.zeros(_faces.shape,dtype=np.float64)
    I_face[:,1:] = faces

    # go throuth the points and test its neighbour 
    for i in range(len(points)):
        i_nei_index = np.where(faces==i)
        nei_faces = faces[i_nei_index[0]] # get all the faces have point i
        nei_points = np.unique(nei_faces.reshape([-1])) # get all the points that form the faces
        nei_nei = []
        for j in nei_points:
            j_nei_index = np.where(faces==j)
            j_nei_faces = faces[j_nei_index[0]]
            j_nei_points = np.unique(j_nei_faces.reshape([-1]))
            nei_nei.append(j_nei_points)
        
        intersection = nei_nei[0]
        for x in nei_nei[1:]:
            intersection = np.intersect1d(intersection,x) # points id intersection
        if len(intersection) == 4:
            _bonds_ij = [[i,j] for i in range(4) for j in range(i)]
            _bonds = [[intersection[i],intersection[j]] for i,j in _bonds_ij] # all the bonds points id in intersection
            _b_points = [[points[i],points[j]] for i,j in _bonds] # all the points coordination  [-1,2,3]
            mid = np.mean(_b_points,axis=1) # mid point of each bond
            index_value = [spin(x) for x in mid] # spin value of each mid point
            remove_bond = np.where(index_value==np.min(index_value))[0] # bonds that need to be removed
            remove_bond_points = _bonds[remove_bond] # points that need to be removed
            # find the faces that contain the bond
            for k,l in remove_bond_points:
                nei_k = np.where(faces==k)
                nei_l = np.where(faces==l)
                _rm_face = np.intersect1d(nei_k[0],nei_l[0])
                I_face[_rm_face,0] = -1
        if len(intersection) >4:
            raise Warning("intersection points > 4")
    reface= I_face[np.where(I_face[:,0]!=-1)]
    return points,reface
            
            

    

        
        
        
    

def _read_stl(mesh,allow_overlap=False):
    """
    Reads a mesh in STL format and extracts the points, faces, bonds, bond types, and dihedral neighbours.

    Args:
    - mesh: a PyVista mesh object in STL format

    Returns:
    - points: a numpy array of shape (n_points, 3) containing the coordinates of the mesh points
    - faces: a numpy array of shape (n_faces, 3) containing the indices of the points that form each face
    - bonds: a numpy array of shape (n_bonds, 2) containing the indices of the points that form each bond
    - bond_type: a numpy array of shape (n_bonds,) containing the type of each bond
    - neighbour: a numpy array of shape (n_dihedrals, 6) containing the indices of the faces and points that form each dihedral neighbour
    """
    points = mesh.points
    faces = np.array(mesh.faces,dtype=np.uint32)
    faces = faces.reshape((-1,4))[:,1:]
    neighbour = []
    # l_nei=0 
    bonds = []
    # bond_neighbour = []
    
    for i in range(mesh.n_faces):
        c = faces[i]
        for n_ in c:
            for m_ in c:
                if n_ < m_:
                    bonds.append([n_,m_])
    bonds = np.unique(np.array(bonds,dtype=np.uint32),axis=0)
    bond_type = np.ones(len(bonds),dtype=np.uint8)
    for _i  in range(len(bonds)):
        bond = bonds[_i] 
        a,b = bond # vertices of one bond
        a_faces = np.where(faces==a)[0] # faces that contain vertex a
        b_faces = np.where(faces==b)[0] # faces that contain vertex b
        face_nei = np.intersect1d(a_faces,b_faces) #`faces index that contain both a and b
        if len(face_nei) > 2 :
            if allow_overlap:
                ns = []
                ns_f = []
                for x in face_nei:
                    n = np.setdiff1d(faces[x],bond)
                    if len(n) != 1:
                        raise Warning("neighbour face num > 2")
                    ns.append(n[0])
                    ns_f.append(x)
                
                for i in range(len(ns)):
                    for j in range(i):
                        if i != j:
                            n_k = ns[i]
                            n_l = ns[j]
                            n_k, n_l = min(n_k,n_l),max(n_k,n_l)
                            neighbour.append([ns_f[i],ns_f[j],n_k,a,b,n_l])
                            
                        
                
                
            else:    
                print(a_faces,b_faces,face_nei)
                raise IndexError("neighbour face num > 2")
            
            
        if len(face_nei) == 2:
            face1,face2 = face_nei
            f1 = faces[face1]
            f2 = faces[face2]
            # print(f1,bond)
            # print(f2,bond)
            n1 = np.setdiff1d(f1,bond)
            n2 = np.setdiff1d(f2,bond)
            if (len(n1) != 1 ) or (len(n2)!= 1):
                print(n1,n2)
                raise IndexError('bond neighbour num error')
            assert a < b
            n_i = n1[0]
            n_k = n2[0]
            n_t = 0
            if n_i > n_k:
                n_t = n_k
                n_k = n_i
                n_i = n_t
            neighbour.append([face1, face2,n_i,a,b,n_k])
        # else:
        #     bond_type[_i] = 2
    l_nei = len(neighbour)
    neighbour = np.array(neighbour)[:,-4:]
    neighbour = np.unique(neighbour,axis=0)
    # assert len(neighbour) == l_nei
    # print(bond_type)
    
    return points,faces,bonds,bond_type,neighbour
    

    


def stl2dat(file:str,file_out,box,expand,bond_ps:list,dihedral_ps:list,mesh=None,allow_overlap=False):
    
    '''
    Args:file ,output file name, box size, bond potential :list, dihedral potential :list
    
    '''
    if mesh is None:
        mesh = pv.read(file)
    points,faces, bonds ,bond_type,neighbour = _read_stl(mesh,allow_overlap=allow_overlap)
        
    head = "LAMMPS Description \n"
    system_info = f'{len(points):d} atoms  \n{len(bonds):d} bonds     \n0 angles  \n{len(neighbour)} dihedrals \n0 impropers\n'
    atom_info = f'1 atom types   \n{len(bond_ps):d} bond types  \n0 angle types    \n{len(dihedral_ps):d} dihedral types  \n0 improper types  \n'
    
    f = open(file_out,'w')
    f.write(head)
    f.write('\n')
    f.write(system_info)
    f.write('\n')
    f.write(atom_info)
    f.write('\n')
    
    f.write("%0.2f %0.2f xlo xhi   \n%0.2f %0.2f ylo yhi \n%0.2f %0.2f zlo zhi \n"%(box[0,0],box[0,1],box[1,0],box[1,1],box[2,0],box[2,1]))
    f.write('\n')
    
    f.write("Masses\n")
    f.write("\n")
    f.write("\t1  12\n")
    f.write("\n")
    
    f.write("Bond Coeffs\n")
    f.write("\n")
    for x in bond_ps:
        f.write('\t')
        f.write(x)
        f.write('\n')
    f.write("\n")

    f.write("Dihedral Coeffs\n")
    f.write("\n")
    for x in dihedral_ps:
        f.write('\t')
        f.write(x)
        f.write('\n')
    f.write('\n')
    
    f.write("Atoms\n")
    f.write("\n")
    
    count = 1
    for p in points:
        f.write(f'\t{count:d} 1 1 0 {p[0]*expand} {p[1]*expand} {p[2]*expand}\n')
        count += 1
    f.write('\n')
    
    
    f.write("Bonds\n")
    f.write("\n")
    an =  1
    for _ in range(len(bonds)):
        bond = bonds[_]
        f.write("\t%d\t%d  %d  %d\n"%(an,bond_type[_],bond[0]+1,bond[1]+1))
        an += 1

    f.write("\n")

    if len(dihedral_ps) > 0:
        f.write('Dihedrals\n')
        f.write("\n")
        din = 1
        for dim in neighbour:
            di = dim
            f.write(f'\t{din} 1 {di[0]+1:d} {di[1]+1:d} {di[2]+1:d} {di[3]+1:d}\t#{dim} {faces[dim[0]]} {faces[dim[1]]}\n')
            din += 1
    
    f.close()




