import paraview.simple as pv

# Load the STL file
stl_reader = pv.OpenDataFile('/Volumes/tianjie 1/code/research/prj3/sim_dump/0.50_0.00_0.00_10/x.comp.load.1.10.vtk')
stl_mesh = pv.GetActiveSource()


# Set up a face light
# face_light = pv.AddLight()
# face_light.Coords = [0, 0, 5]
# face_light.DiffuseColor = [1, 1, 1]
# face_light.Intensity = 1
# face_light.Positional = 0
# face_light.UseIntensityAsAttenuation = 0

# Set up a spotlight
# spotlight = pv.AddLight()
# spotlight.Coords = [0, 0, 5]
# spotlight.DiffuseColor = [1, 1, 1]
# spotlight.Intensity = 1
# spotlight.Positional = 1
# spotlight.UseIntensityAsAttenuation = 0
# spotlight.SwitchType = 'Spot'
# spotlight.SpotConeAngle = 30

# Apply a material to the mesh
# material = pv.AddMaterial()
# material.AmbientColor = [0.2, 0.2, 0.2]
# material.DiffuseColor = [0.8, 0.8, 0.8]
# material.SpecularColor = [1, 1, 1]
# material.SpecularPower = 100
# material.Opacity = 1

# Show the mesh with the lights and material
pv.SetActiveSource(stl_mesh)
pv.Show()
pv.Render()

 