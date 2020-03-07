within WaterSideSystem.BaseClasses.Control.Example;
model pid
  import WaterSideSystem;
  extends Modelica.Icons.Example;
  WaterSideSystem.BaseClasses.Control.pid conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    reverseAction=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Step On(
    startTime=10,
    height=-1,
    offset=1) annotation (Placement(transformation(extent={{-70,12},{-50,32}})));
  Modelica.Blocks.Sources.Constant Us(k=0)
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Modelica.Blocks.Sources.Constant Um(k=1)
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
equation
  connect(On.y, conPID.On) annotation (Line(
      points={{-49,22},{-32,22},{-32,8},{-12,8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(Us.y, conPID.u_s) annotation (Line(
      points={{-49,-10},{-32,-10},{-32,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(Um.y, conPID.u_m) annotation (Line(
      points={{-49,-40},{0,-40},{0,-12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Control/Example/Test_PID.mos"
        "Simulate and plot"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end pid;
