from mpi4py import MPI
import numpy as np
import src.agent as agent
import numpy as np
import matplotlib.pyplot as plt
import pyacvd
import os
import pyvista as pv
import numpy as np


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
        if t_1 ==0 and len(t1) != 0:
            raise IndexError("t_1 should not be 0")
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
        
        
  


grid = pv.ImageData(
    dimensions=(201,201,201),
    spacing=(0.5,0.5,0.5),
)
dirc = 'spinodal_model'
os.system(f'mkdir -p {dirc}')
model_size = 100
theta = np.linspace(0,1,11) 
le= len(theta) 



# Create a list of job IDs (only on the root processor)
jobs = []
for i in range(le):
        for j in range(le-i):
            for k in range(le-i-j):
                t_1 = theta[i]
                t_2 = theta[j]
                t_3 = theta[k]
                if t_1 != 0 or t_2 !=0 or t_3 !=0:
                    for m in [5,7,10]:
                        jobs.append([t_1,t_2,t_3,m])

print(len(jobs))

# define the job function                     
def GenerateModel(job):
    print(f'Generating Model {job}' )
    t_1,t_2,t_3,m = job

    #*test*#
    ##f = open(dirc+f'/{t_1:0.2f}_{t_2:0.2f}_{t_3:0.2f}_{m}.stl','w')
    ##f.close()
    #*test end*#
    print(f'{t_1}_{t_2}_{t_3},{m}')
    # Generate Spinodal Surface
    spin = agent.Spinodal(a=1,b=1,c=1,t_1=t_1,t_2=t_2,t_3=t_3,l=500,beta=m*np.pi/model_size)
    # print(t_1,t_2,t_3,spin.N.shape)
    values = np.array([spin(X) for X in grid.points])
    surf = grid.contour([0],scalars=values)
    mesh = surf.triangulate(progress_bar=True)
    M = pyacvd.Clustering(mesh)
    # M.plot()
    M.cluster(20000)
    # M.plot()
    # M.create_mesh().plot()
    mesh = M.create_mesh()
    print(f'{t_1}_{t_2}_{t_3}')
    pv.save_meshio(dirc+f'/{t_1:0.2f}_{t_2:0.2f}_{t_3:0.2f}_{m}.stl',M.create_mesh())

# Initialize MPI
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()


# Master process (root)
if rank == 0:
    # List to hold results
    results = []

    # Initially distribute jobs to all workers
    print(size)
    for i in range(1, size):
        if len(jobs) == 0:
            break
        job = jobs.pop()
        comm.send(job, dest=i, tag=1)

    # Collect results and distribute remaining jobs
    while len(jobs) > 0:
        status = MPI.Status()
        result = comm.recv(source=MPI.ANY_SOURCE, tag=MPI.ANY_TAG, status=status)
        results.append(result)

        job = jobs.pop()
        comm.send(job, dest=status.source, tag=1)

    # Collect remaining results
    for i in range(1, size):
        result = comm.recv(source=MPI.ANY_SOURCE)
        results.append(result)

    # Display results
    print("Results:", results)
       
# Worker processes
else:
    while True:
        # Receive a job from the master process
        job = comm.recv(source=0, tag=MPI.ANY_TAG, status=None)

        # If no more work, break
        if job is None:
            break

        # Process the job and send the result back to the master
        result = GenerateModel(job)
        comm.send(result, dest=0)

os._exit(0)
