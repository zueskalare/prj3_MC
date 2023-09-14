# draw biconcave
import plotly.graph_objects as go
import numpy as np
from plot_layout import layout
def get_annotation(align,text,x,y,z,bgcolor='white',color='black',font_size=40):
        annotation = {}
        annotation['align'] = align
        annotation['x'] = x
        annotation['y'] = y
        annotation['z'] = z
        annotation['text'] = text
        annotation['showarrow'] = False
        annotation['bgcolor'] = bgcolor
        annotation['font'] = dict(
                family="Times New Roman",
                size=font_size,
                color=color
        )
        return annotation

def plot_3d(a,b,c,file):
        '''
        a,b,c must < 1
        '''

        phi = np.linspace(0, np.pi/4, 100)
        phi = np.concatenate([phi,np.linspace(np.pi/4*3,np.pi,100)],-1)
        theta = np.linspace(0, 2*np.pi, 100)
        phi, theta = np.meshgrid(phi, theta)
        thickness = 0.35
        thick = thickness*np.cos(2*phi)

        # a,b,c = [0.98,0.6,0.3]
        r1 = a*np.cos(2*phi)
        x1 = r1*np.cos(phi)
        y1 = thick*np.sin(phi)*np.cos(theta) #* (z-0.9)**2
        z1 = thick*np.sin(phi)*np.sin(theta) #* (z-0.9)**2


        r2 = b*np.cos(2*phi)
        y2 = r2*np.cos(phi)
        x2 = thick*np.sin(phi)*np.cos(theta) #* (z-0.9)**2
        z2 = thick*np.sin(phi)*np.sin(theta) #* (z-0.9)**2


        r3 = c*np.cos(2*phi)
        z3 = r3*np.cos(phi)
        x3 = thick*np.sin(phi)*np.cos(theta) #* (z-0.9)**2
        y3 = thick*np.sin(phi)*np.sin(theta) #* (z-0.9)**2

        # x = np.concatenate([x1,x2,x3],-1)
        # y = np.concatenate([y1,y2,y3],-1)
        # z = np.concatenate([z1,z2,z3],-1)
        surf = []
        ophi = np.linspace(0, np.pi, 20)
        otheta = np.linspace(0, 2*np.pi, 20)
        ophi, otheta = np.meshgrid(ophi, otheta)
        ox = np.sin(ophi)*np.cos(otheta)
        oy = np.sin(ophi)*np.sin(otheta)
        oz = np.cos(ophi)
        Sueface_out = go.Surface(
                x = ox,y = oy,z = oz,
                surfacecolor=oz,showscale=False,
                lighting=dict(
                        ambient=0.5,
                        diffuse=0.5,
                        specular=0.5,
                        roughness=0.5,
                        fresnel=0.2
                ),
                # mode = 'lines',
                colorscale=[[0, 'black'], [0.5, 'black'], [1.0, 'black']],
                opacity=0.1
        )
        
        for i in range(20):
                surf.append(go.Scatter3d(
                        x = ox[i],
                        y = oy[i],
                        z = oz[i],
                        mode = 'lines',
                        line=dict(width=1.5,color='black'),
                        showlegend=False,
                        hoverinfo='none',
                        ))  
                surf.append(go.Scatter3d(
                        x = ox[:,i],
                        y = oy[:,i],
                        z = oz[:,i],
                        mode = 'lines',
                        line=dict(width=1.5,color='black'),
                        showlegend=False,
                        hoverinfo='none',
                        ))
        # draw the cones and arch surfaces
        
        
        
        
        Surface1 = go.Surface(
                z=z1, x=x1, y=y1,surfacecolor=np.abs(x1),showscale=True,
                lighting=dict(
                        ambient=0.5,
                        diffuse=0.5,
                        specular=0.5,
                        roughness=0.8,
                        fresnel=0.2
                        ),
                coloraxis='coloraxis',
                # lightposition=dict(x=10000,y=0,z=0),
                )
        Surface2 = go.Surface(
                z=z2, x=x2, y=y2,surfacecolor=np.abs(y2),showscale=True,
                lighting=dict(
                        ambient=0.5,
                        diffuse=0.5,
                        specular=0.5,
                        roughness=0.8,
                        fresnel=0.2
                        ),
                coloraxis='coloraxis',
                # lightposition=dict(x=10000,y=0,z=0),
                )
        Surface3 = go.Surface(
                z=z3, x=x3, y=y3,surfacecolor=np.abs(z3),showscale=True,
                lighting=dict(
                        ambient=0.5,
                        diffuse=0.5,
                        specular=0.5,
                        roughness=0.8,
                        fresnel=0.2
                        ),
                coloraxis='coloraxis',
                # lightposition=dict(x=10000,y=0,z=0),
                )


        m = 1
        # drawline -a,a
        # Create orientation axis lines
        linex = go.Scatter3d(
                x=[-m,m],
                y = [0,0],
                z = [0,0],
                line=dict(width=5,color='black'),
                mode='lines',
                # lightposition=dict(x=10000,y=0,z=0),
        )
        arrowx = go.Cone(
                        x = [m],
                        y = [0],
                        z = [0],
                        u = [1],
                        v = [0],
                        w = [0],
                        showscale=False,
                        lighting=dict(
                                ambient=0.5,
                                diffuse=0.5,
                                specular=0.5,
                                roughness=0.8,
                                fresnel=0.2
                        ),
                        text='asdfasdfasdf',
                        sizemode="absolute",
                        sizeref=0.1,
                        anchor="tail",
                        colorscale=[[0, 'black'], [0.5, 'black'], [1.0, 'black']]
                        
                        
        )
        liney = go.Scatter3d(
                x=[0,0],
                y = [-m,m],
                z = [0,0],
                line=dict(width=5,color='black'),
                mode='lines',
                # lightposition=dict(x=10000,y=0,z=0),
        )
        arrowy = go.Cone(
                        x = [0],
                        y = [m],
                        z = [0],
                        u = [0],
                        v = [1],
                        w = [0],
                        showscale=False,
                        lighting=dict(
                                ambient=0.5,
                                diffuse=0.5,
                                specular=0.5,
                                roughness=0.8,
                                fresnel=0.2
                        ),
                        text='asdfasdfasdf',
                        sizemode="absolute",
                        sizeref=0.1,
                        anchor="tail",
                        colorscale=[[0, 'black'], [0.5, 'black'], [1.0, 'black']]
                        
        )
        linez = go.Scatter3d(
                x=[0,0],
                y = [0,0],
                z = [-m,m],
                line=dict(width=5,color='black'),
                mode='lines',
                # lightposition=dict(x=10000,y=0,z=0),
        )
        arrowz = go.Cone(
                        x = [0],
                        y = [0],
                        z = [m],
                        u = [0],
                        v = [0],
                        w = [1],
                        showscale=False,
                        lighting=dict(
                                ambient=0.5,
                                diffuse=0.5,
                                specular=0.5,
                                roughness=0.8,
                                fresnel=0.2
                        ),
                        text='asdfasdfasdf',
                        sizemode="absolute",
                        sizeref=0.1,
                        anchor="tail",
                        colorscale=[[0, 'black'], [0.5, 'black'], [1.0, 'black']] 
        )
        annotation = []
        annotation.append(get_annotation('center','X',m+0.15,0,0,bgcolor='rgba(255,255,255,0)',color='black',font_size=40))
        annotation.append(get_annotation('center','Y',0,m+0.15,0,bgcolor='rgba(255,255,255,0)',color='black',font_size=40))
        annotation.append(get_annotation('center','Z',0,0,m+0.15,bgcolor='rgba(255,255,255,0)',color='black',font_size=40))

        
        surf.extend([Surface1,Surface2,Surface3,linex,liney,linez,arrowx,arrowy,arrowz,Sueface_out])
        fig = go.Figure(data=surf)
        fig.update_layout(layout)
        fig.update_layout(
                showlegend=False,
                scene=dict(
                        annotations=annotation,
                        bgcolor='rgba(0,0,0,0)',
                        aspectmode='cube',
                        aspectratio=dict(x=1,y=1,z=1),
                        xaxis=dict(backgroundcolor='rgba(255,255,255,0)',range=[-1.3,1.3], showbackground=False,dtick = 0.4,
                                tickfont=dict(size=18,color='rgba(255,255,255,0)',family='Times New Roman'),
                                showticklabels=False,title=dict(text='<b></b>',font_size =40,font_color='black',font_family = "Times New Roman"),
                                ticklen = 12,tickcolor = 'rgba(255,255,255,0)',ticks="inside",tickwidth=5,
                                showgrid=False, zeroline=False, showline=False, showspikes=False,
                                tickprefix='<b>',ticksuffix='</b>'),
                        yaxis=dict(backgroundcolor='rgba(255,255,255,0)',range=[-1.3,1.3], showbackground=False,dtick = 0.4,
                                tickfont=dict(size=18,color='rgba(255,255,255,0)',family='Times New Roman'),
                                showticklabels=False,title=dict(text='<b></b>',font_size =40,font_color='black',font_family = "Times New Roman"),
                                ticklen = 12,tickcolor = 'rgba(255,255,255,0)',ticks="inside",tickwidth=5,
                                showgrid=False, zeroline=False, showline=False, showspikes=False,
                                tickprefix='<b>',ticksuffix='</b>'),
                        zaxis=dict(backgroundcolor='rgba(255,255,255,0)',range=[-1.3,1.3], showbackground=False,dtick = 0.4,
                                tickfont=dict(size=18,color='rgba(255,255,255,0)',family='Times New Roman'),
                                showticklabels=False,title=dict(text='<b></b>',font_size =40,font_color='black',font_family = "Times New Roman"),
                                ticklen = 12,tickcolor = 'rgba(255,255,255,0)',ticks="inside",tickwidth=5,
                                showgrid=False, zeroline=False, showline=False, showspikes=False,
                                tickprefix='<b>',ticksuffix='</b>'),
                        camera=dict(
                        up=dict(x=0, y=0, z=1),
                        center=dict(x=0, y=0, z=0),
                        eye=dict(x=1.5*0.9, y=1.5*0.9, z=0.6*0.9)  # Adjust the coordinates to set the view angle
                        ),
                ),
                margin=dict(l=0, r=0, b=0, t=0),
                # change the location of coloraxis
                coloraxis=dict(
                        cauto = True,
                        colorscale='Jet',
                        # cmin = 0,
                        # cmax = 1,
                        colorbar=dict(
                                title=dict(text='',font_family = "Times New Roman",font_size = 50),
                                # dtick = 0.2,
                                tickmode='array', # choose tickmode for color bar array is for customized tick labelss
                                tickvals=np.linspace(0,1,6),
                                titleside='right',
                                tickprefix='<b>',
                                ticksuffix='</b>',
                                # tick0 = 1,
                                tickfont=dict(size=20,family='Times New Roman'),
                                thickness=20,
                                len=0.5,
                                x=0.85, # the location for color bar 
                                y=0.53,
                                ),
                                # colorbar_x=-0.1,
                                # colorbar_y=0.5
                        )
                )
        fig.write_image(file)
        return fig
        # fig.show()

# plot_3d(0.98,0.6,0.3,'biconcave.jpg')