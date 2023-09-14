# import numba
import numpy as np
from .agent import singleType_atomic_output as op
import os
from lammps import PyLammps
import copy
import tensorflow as tf
from .agent import function

import math
class MonteCarlo():
    def __lmp_init__(self,lmp,data,pot:list):
        '''
        initialize lmp
        '''
        pre = """clear
units metal
dimension 3
atom_style atomic
boundary s s s"""
        lmp.lmp.commands_string(pre)
        lmp.read_data(data)
        for x in pot:
            lmp.command(x)

        box_ste ="""
mass * 12
neighbor  1.0 nsq
"""

        lmp.lmp.commands_string(box_ste)
    
                
        
    def __init__(self,name,function:function,box_size,atom_num,potential,target_potential='pe'):
        """

        Args:
            name (_type_): _description_
            function (function): _description_
            box_size (_type_): _description_
            atom_num (_type_): _description_
            potential not optional
            target_potential (str, optional): _description_. Defaults to 'pe'.
        
        """
        self.name = name
        self.function  = function
        self.box = box_size
        self.atom_num = atom_num
        self.potential = potential
        self.intial = self.__init_config__()
        self.config = copy.deepcopy(self.intial)
        self.target = target_potential
        
        self.Energy = []
        if os.path.exists(self.name)==False:
            os.mkdir(name)
        
        # lmp initial
        self.lmp = PyLammps()
        self.step = 0
        op(self.intial,self.box,f'{self.name}/{self.step}.dat')
        self.__lmp_init__(self.lmp,f'{self.name}/{self.step}.dat',self.potential)
        self.lmp.run(0)
        e_i = self.current_energy()
        self.Energy.append(e_i)
        
    def __init_config__(self):
        res = []
        for i in range(self.atom_num):
            while True:
                x = np.random.uniform(self.box[0][0],self.box[0][1])
                y = np.random.uniform(self.box[1][0],self.box[1][1])
                z = np.random.uniform(self.box[2][0],self.box[2][1])
                z0 = np.array(self.function.solve_res([x,y,None]))
                if len(z0) ==0:
                    continue
                res_t = np.abs(z0 -z )
                print(z0,res_t)
                index = np.where(res_t==np.min(res_t))[0][0]
                # print(index)
                break
                
            res.append([x,y,z0[index]])
            # print('yes')
        return np.array(res)
            
            
    def current_energy(self):
        '''
        calculate current state
        '''
        E_in = self.lmp.eval(self.target)
        
        return E_in
    
    def __run_lmp__(self):
        '''   
        need a func to act run
        '''
        self.lmp.run(1,"pre no post no")

    
    
    def __dump__(self):
        '''
        only output current step
        '''
        cord = self.get_conf()
        op(cord,self.box,f'{self.name}/{self.step}.dat')
        
    
    def random_step(self,batch= 1):
        '''
        random walk of random atom  ` 
        '''
        index = np.random.randint(0,self.lmp.atoms.natoms)
        delta = 1
         
        x0,y0,z0 = self.lmp.atoms[index].position
        _c=0
        
        while True :
            
            vert = self.function.diff(x0,y0,z0)
            rand_pointer = np.random.random(size=3)
            walk = np.cross(vert,rand_pointer)
            walk = walk/np.linalg.norm(walk) * delta *np.random.rand()
            x_=x0+walk[0]
            y_ = y0+walk[1]
            z_0 = self.function.solve_res([x_,y_,None])
            res_t_ = np.abs(np.array(z_0) -(z0+walk[2]) )
            index = np.where(res_t_==np.min(res_t_))
            z_ = max(z_0[index])
            
            
            conf_temp = copy.deepcopy(self.config)
            conf_temp[index][0] = x_
            conf_temp[index][1] = y_
            conf_temp[index][2] = z_
            
            op(conf_temp,self.box,f'{self.name}/temp.dat')
            
            self.__lmp_init__(self.lmp,f'{self.name}/temp.dat',self.potential)
            self.lmp.run(0)
            ei = self.current_energy()
            e = ei
            
            comp = e < self.Energy[self.step]
            if comp == True:
                self.Energy.append(e)
                self.step+=1
                self.config = conf_temp
                break

            elif _c> 100:
                print("reach limit",index)
                break

                
            _c+=1
        if self.step %10 == 0:
            self.__dump__()
            
        return e
            
    def get_conf(self):
        '''
        get current cof
        '''
        return self.config
    
            

        
        
        
                
        