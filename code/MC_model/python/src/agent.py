import numpy as np
import time 
from scipy import special
import copy
from sympy import symbols,Symbol,Function
import sympy
import pyvista as pv


class Spinodal:
    '''
    to have a spinodal shell, a=b=c=1,beta=10*pi/len,t_1,t_2,t_3 < pi/2
    '''
    def __init__(self,a,b,c,t_1,t_2,t_3,beta,ro=0.5,l=100,index = 0):
        '''
        function of spinodal surface
        a,b,c: the length of the axis
        t_1,t_2,t_3: the range of the angle
        ro: the ro of the spinodal surface
        l: the number of the points in the range
        '''
        self.a = a
        self.b = b
        self.c = c
        self.theta1 = t_1
        self.theta2 = t_2
        self.theta3 = t_3
        self.l = l
        self.ro = ro
        self.index = index
        
    
        
        t1 = np.append(np.random.uniform(0,self.theta1,l),np.random.uniform(np.pi-self.theta1,np.pi,l))
        t1 = t1[t1>0]
        t1 = t1[t1<np.pi]
        f1 = np.random.uniform(0,2*np.pi,len(t1))
        n1 = a* np.cos(t1)
        n2 = b*np.sin(t1)*np.cos(f1)
        n3 = c*np.sin(t1)*np.sin(f1)
        t2 = np.append(np.random.uniform(0,self.theta2,l),np.random.uniform(np.pi-self.theta2,np.pi,l))
        t2 = t2[t2>0]
        t2 = t2[t2<np.pi]
        f2 = np.random.uniform(0,2*np.pi,len(t2))
        n2 = np.append(n2,b* np.cos(t2))
        n3 = np.append(n3,c*np.sin(t2)*np.cos(f2))
        n1 = np.append(n1,a*np.sin(t2)*np.sin(f2))
        t3 = np.append(np.random.uniform(0,self.theta3,l),np.random.uniform(np.pi-self.theta3,np.pi,l))
        t3= t3[t3>0]
        t3 = t3[t3<np.pi]
        f3 = np.random.uniform(0,2*np.pi,len(t3))
        n3 = np.append(n3,c* np.cos(t3))
        n1 = np.append(n1,a*np.sin(t3)*np.cos(f3))
        n2 = np.append(n2,b*np.sin(t3)*np.sin(f3))

        
        self.beta = beta # in the paper should be 10*pi/len
        
        self.phy0 = special.erfc(ro)#in the paper is  phy0=sqrt(2)erfc(2*ro-1)
        self.N = np.array(list(zip(n1,n2,n3)))
        self.gamma = np.random.uniform(0,2*np.pi,len(self.N))
        
    def __call__(self,X:np.ndarray):
        phy = np.sqrt(2/len(self.N)) * np.sum(np.cos(self.beta*np.matmul(self.N,X) + self.gamma))-self.index
        return(phy)

    def matrix_call(self,X:np.ndarray):
        phy = np.sqrt(2/len(self.N)) * np.sum(np.cos(self.beta*np.matmul(X,self.N.T) + self.gamma),axis=-1)-self.index
        return phy

        
    
        
        

class function():
    '''
    deprecated
    use grad to have a stable model
    '''
    def __init__(self,func:sympy.Function) -> None:
        self.parameter_length = len(func.free_symbols)
        parameters = list(func.free_symbols)
        self.parameters = copy.deepcopy(parameters)
        self.func = func
        for x in range(self.parameter_length):
            self.func = self.func.xreplace({parameters[x]:self.parameters[x]})
    def call(self,list):
        if len(list)!= self.parameter_length:
            raise IndexError("length does not match")
        res = self.func
        for x in range(self.parameter_length):
            if list[x] != None:
                res  = res.xreplace({self.parameters[x]:list[x]})
        res = sympy.N(res)
        return res 
    def diff_fun(self):
        res = [function(self.func.diff(x)) for x in self.parameters]
        return res
    def diff(self,list):
        res = [function(self.func.diff(x)).call(list) for x in self.parameters]
        return res
    def solve(self,index):
        if index < self.parameter_length:
            return([function(x) for x in sympy.solve(self.func,self.parameters[index])])

    def solve_res(self,list):
        '''the none in list is the res where'''
        index = list.index(None)
        res_f = self.func
        for i in range(self.parameter_length):
            if i!=index:
                res_f = res_f.subs(self.parameters[i],list[i])
        res = sympy.solve(res_f,self.parameters[index])
        return res#[sympy.N(x) for x in res]
        


def singleType_atomic_output(pos:np.array,box_size,filename) -> None:
    f = open(filename,'w')
    t = time.asctime()
    head = f'Lammps -- {t}\n'
    f.write(head)
    # atom_conf
    f.write(f"""\n{len(pos)} atoms

1 atom types

{box_size[0][0]} {box_size[0][1]} xlo xhi
{box_size[1][0]} {box_size[1][1]} ylo yhi
{box_size[2][0]} {box_size[2][1]} zlo zhi
0 0 0 xy xz yz

Masses 

1\t12

Atoms # atomic\n\n""")
    
    
    for id, cord in enumerate(pos,1):
        f.write(f'{id}\t1\t{cord[0]}\t{cord[1]}\t{cord[2]}\n')
        
    f.write("\nVelocities \n \n")
        
    for id, cord in enumerate(pos,1):
        f.write(f'{id}\t{0}\t{0}\t{0}\n')
        
    f.close()
    
    
    
    

# p = np.random.uniform(-5,5,(200,3))
# singleType_atomic_output(p,'test.dat')


__all__= ['singleType_atomic_output']