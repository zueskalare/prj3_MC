import numpy as np
color = dict(
  Grey_to_Red = ["#d7e1ee", "#cbd6e4", "#bfcbdb", "#b3bfd1", "#a4a2a8", "#df8879", "#c86558", "#b04238", "#991f17"],
  Spring_Pastels = ["#fd7f6f", "#7eb0d5", "#b2e061", "#bd7ebe", "#ffb55a", "#ffee65", "#beb9db", "#fdcce5", "#8bd3c7"],
  Pink_Foam = ["#54bebe", "#76c8c8", "#98d1d1", "#badbdb", "#dedad2", "#e4bcad", "#df979e", "#d7658b", "#c80064"],
  monet= ['#7A91BF','#4465A6','#7A91BF','#B8D5D9','#F2AB6D','#D9B596'],
  molandi = ['#e4cd97', '#e0c1b7', '#987e5b', '#85786b', '#422718', '#6d6f7b', '#665f7a', '#1c2e57', '#3b466a', '#bdad92', '#b08171', '#7c5e60'],
  many = ['#75a5cf','#ae799e','#c7bdd7','#cfcffc','#F7DFF7','#91b9d5','#d2ca83','#bc7857','#f5c66f','#7aaeb4'],
  single = ['#FAD8B9','#DEA0C3','#BEBDF5','#A0DED3'],
  two = [['#7C97A6','#F2E3CE'],['#A67F76','#C4F2E3']],
  three = [['#A88E87','#F3D5CC','#838AA6'],['#8A9FA8','#D1E8F2','#A6A486']],
  jianbian =[['#0D4A70','#226E9C','#3C93C2','#6Cb0D6','#9EC9E2','#C5E1EF'],['#06592A','#22BB38','#40AD5A','#6CBA7D','#9CCEA7','#CDE5D2'],['#B10026','#E31A1C','#FC4E2A','#FD8D3C','#FEB24C','#FED976'],
             ['#6e005f','#Ab1866','#d12959','#e05c5c','#f08f6e','#FABf7b']],
  nature = ['#a3243d','#e7bf44','#d09048','#488c4f','#4f86c6','#a2c398']
  
)


layout = {
  "showlegend": True, 
  'legend':{
    'font_family':'Times New Roman',
    'font_size':40,
    'orientation':'h',
    'bgcolor':'#FFFFFF',
    'bordercolor':'#FFFFFF',
    'borderwidth':2,
    'itemwidth':50,
    'x':0.01,
    'y':1.1
    },
  
  'coloraxis1':dict(
                    cauto = True,
                    colorscale='Jet',
                    # cmin = 0,
                    # cmax = 1,
                    colorbar=dict(
                            title=dict(text='',font_family = "Times New Roman",font_size = 20),
                            # dtick = 0.2,
                            tickmode='array', # choose tickmode for color bar array is for customized tick labelss
                            tickvals=np.linspace(0,1,6),
                            titleside='right',
                            tickprefix='<b>',
                            ticksuffix='</b>',
                            # tick0 = 1,
                            tickfont=dict(size=15,family='Times New Roman'),
                            thickness=20,
                            len=0.8,
                            x=0.85, # the location for color bar 
                            y=0.43,
                            ),
                            # colorbar_x=-0.1,
                            # colorbar_y=0.5
                    ),
  
  'coloraxis' :dict(
    colorscale = [[0,color['jianbian'][0][0]],[0.3,color['jianbian'][0][-1]],[0.7,color['jianbian'][2][-1]],[1,color['jianbian'][2][0]]],
    showscale = True,
    colorbar = dict(
      title = dict(
          text = '<b></b>',
          font = dict(size= 40),
          side = 'right',
      ),
      # tickmode = 'linear',
      nticks = 5,
      ticklen = 10,
      tickwidth =5,
      # dtick = 0.05,
      tickfont = dict(
          family='Times New Roman',
          size = 40
      ),
      tickprefix='<b>',
      ticksuffix='</b>',
    
    ),
  ),
  # 'coloraxis':{
  #   # 'title':{'text':'<b>Generation','font':{'color':'#222222','size':20}},
  #   'tickfont':{'color':'#222222','size':10},
  #   'colorscale':[[0,color['jianbian'][0]],[0.5,color['jianbian'][1]],[1,color['jianbian'][2]]]
  # },
  'font_family':'Times New Roman',
  'plot_bgcolor':'#FFFFFF',
  'paper_bgcolor':'rgba(255,255,255,0)',
  'width':1200,
  'height':1000,
  "title": {"text": None,'font_family':'Times New Roman','font_size':40,'xanchor':None}, 
  "xaxis": {
    "title": {"text": "Compression Ratio",'font_size':50,'font_family':'Times New Roman',}, 
    "zeroline": True,
    'linecolor':'#666666',
    'linewidth':2,
    'showline':True,
    'tickfont':{'size':40},
    'ticklen':10,
    'tickwidth':2,
    'tickcolor':'#333333',
    'ticks':'inside',
    'side':'bottom',
    'anchor':'x',
    # 'showspikes':True,
    'showgrid': True,
    'gridcolor':'#ffffff',
    'mirror':True,
    'tickprefix':'<b>',
    'ticksuffix':'</b>',
    
  }, 
  
  "yaxis": {
    "title": {"text": "Poisson's Ratio",'font_size':50,'font_family':'Times New Roman',}, 
    "zeroline": True,
    'linecolor':'#666666',
    'linewidth':2,
    'showline':True,
    'tickfont':{'size':40},
    'ticklen':10,
    'tickwidth':2,
    'tickcolor':'#333333',
    'ticks':'inside',
    'mirror':True,
    'anchor':'y',
    'side':'left',
    'tickprefix':'<b>',
    'ticksuffix':'</b>',
    
  },
  'yaxis2':{
    "title": {"text": "Poisson's Ratio",'font_size':50,'font_family':'Times New Roman','font_color':'#991f17'}, 
    "zeroline": True,
    'linecolor':'#991f17',
    'linewidth':2,
    'showline':True,
    'tickfont':{'size':40,'color':'#991f17'},
    'ticklen':10,
    'tickwidth':2,
    'tickcolor':'#991f17',
    'ticks':'inside',
    'side':'right',
    'anchor':'y2',
    'overlaying':'y',
    'tickprefix':'<b>',
    'ticksuffix':'</b>',

  },
  'xaxis2':{
    "title": {"text": "Poisson's Ratio",'font_size':50,'font_family':'Times New Roman','font_color':'#0072bd'}, 
    "zeroline": True,
    'linecolor':'#0072bd',
    'linewidth':2,
    'showline':True,
    'tickfont':{'size':40,'color':'#0072bd'},
    'ticklen':10,
    'tickwidth':2,
    'tickcolor':'#0072bd',
    'ticks':'inside',
    'side':'top',
    'anchor':'x2',
    'tickprefix':'<b>',
    'ticksuffix':'</b>',
    # 'overlaying':'x',
  },


}


template = {
  'colorbar':{
    'tickfont':{
      'family':'Times New Roman',
      'size':20
    }
  },
  'scatter_m_l':dict(
    mode='markers+lines',
    marker = dict(
      size = 20,
    ),
    line = dict(
      width = 5,
    )
  )
}
shape = ['circle','triangle-up','square','cross','x','square','triangle-down']
__all__=['layout','color','shape','template']