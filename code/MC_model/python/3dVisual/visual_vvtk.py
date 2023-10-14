from paraview.simple import *
import os 
ResetSession()
# Load the .vtk file
# file = '/Volumes/tianjie 1/code/research/prj3/sim_dump/0.50_0.00_0.00_10/x.comp.load.1.10.vtk'
fail = []
for root, dirs, files in os.walk('/Volumes/tianjie 1/code/research/prj3/sim_dump'):
    for _file in files :
        if _file.endswith('.vtk') and  _file[0] != '.':
            file = os.path.join(root, _file)

            ori = file.split('/')[-1].split('.')[0]
            ori = str.upper(ori)
            print(ori)
            try:
                reader = OpenDataFile(file)
            except BaseException:
                fail.append(file)
                continue
            source = GetActiveSource()


            # Update the view
            view = GetActiveView()
            if not view:
                # Create a new view if one doesn't exist.
                view = CreateRenderView()

            # Show the data in the view
            display = Show(reader, view)




            # Adjust material properties
            # Assuming the data loaded has a property named 'Surface' (often the default for many file types)
            display.Representation = 'Surface'  # Make sure we are in Surface representation mode
            display.AmbientColor = [0.5, 0.5, 0.5]  # Adjust the ambient color
            display.DiffuseColor = [1, 1, 1]       # Adjust the diffuse color (default is white)
            display.SpecularColor = [1, 1, 1]      # Adjust the specular color (default is white)
            display.Specular = 0.5                 # Adjust specular reflection (default is 0.1)
            display.SpecularPower = 30             # Adjust the specular power (default is 100)
            display.Roughness=0.8
            display.Diffuse=0.75


            Render(view)

            # get color transfer function/color map for 'stress'
            stressLUT = GetColorTransferFunction('stress')
            # get opacity transfer function/opacity map for 'stress'
            stressPWF = GetOpacityTransferFunction('stress')
            # set scalar coloring
            ColorBy(display, ('POINTS', 'stress', ori))
            # rescale color and/or opacity maps used to exactly fit the current data range
            display.RescaleTransferFunctionToDataRange(False, False)
            # Update a scalar bar component title.
            UpdateScalarBarsComponentTitle(stressLUT, display)
            # get 2D transfer function for 'stress'
            stressTF2D = GetTransferFunction2D('stress')
            stressLUTColorBar = GetScalarBar(stressLUT, view)
            stressLUTColorBar.WindowLocation = 'Any Location'
            stressLUTColorBar.ScalarBarLength = 0.33
            stressLUTColorBar.Position = [0.8317775974025974, 0.1214539007092199]
            stressLUTColorBar.TitleColor = [0.0, 0.0, 0.0]
            stressLUTColorBar.TitleFontFamily = 'Times'
            stressLUTColorBar.LabelFontFamily = 'Times'
            # Properties modified on stressLUTColorBar
            stressLUTColorBar.Title = 'Stress'
            stressLUTColorBar.ComponentTitle = f'{ori}'
            stressLUTColorBar.HorizontalTitle = 1
            stressLUTColorBar.LabelColor = [0.0, 0.0, 0.0]
            stressLUTColorBar.TitleBold = 1
            stressLUTColorBar.LabelBold = 1

            # Enable Ray Tracing
            view.EnableRayTracing = True
            # Selecting the ray tracing backend:
            # - 'OSPRay raycaster' for basic ray tracing.
            # - 'OSPRay pathtracer' for more advanced path tracing effects.
            # Choose the one that fits your needs best.
            display.OSPRayUseScaleArray = 'All Exact'
            view.BackEnd = 'OSPRay raycaster'


            view.UseColorPaletteForBackground = 0
            view.Background = [1.0, 1.0, 1.0]

            # Using the camera
            camera = view.GetActiveCamera()

            view.CameraPosition = [-633.9923099106263, -744.7561985913325, 643.9023539933225]
            view.CameraFocalPoint = [199.82485774159417, 202.0683641433719, 201.43314146995536]
            view.CameraViewUp = [0.20327447180691352, 0.26187955477665315, 0.9434503632420745]
            view.CameraParallelScale = 346.03504533917487
            # # Set initial camera properties
            # camera.SetPosition(10, -10, 10)  # X, Y, Z coordinates of the camera
            # camera.SetFocalPoint(0, 0, 0)  # X, Y, Z coordinates the camera is looking at
            # camera.SetViewUp(0, 1, 0)      # Defines the "up" direction for the camera

            # # Apply an azimuthal rotation of 45 degrees to the camera
            # camera.Azimuth(45)

            Render(view)

            # Save a screenshot
            SaveScreenshot(file[:-4] + '.png')

            # Optionally, to keep the pvpython session open and inspect the data
            # StartInteractive()

            # Delete(GetSources())

            ResetSession()
            
os.system(f'echo {fail} > /Volumes/tianjie 1/code/research/prj3/sim_dump/fail.txt')