within WaterSideSystem.BaseClasses.Control.Example;
model dPControl

  import ChillerPlantSystem = WaterSideSystem;
 extends Modelica.Icons.Example;
  ChillerPlantSystem.BaseClasses.Control.dPControl
                                dPCon(dPSetPoi(displayUnit="Pa") = 478250)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Sine dP(
    freqHz=1/43200,
    amplitude=239125,
    offset=239125)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Step y(
    startTime=43200,
    height=-1,
    offset=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation

  connect(dP.y, dPCon.dP) annotation (Line(
      points={{-39,-10},{-32,-10},{-32,4},{-22,4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(y.y, dPCon.yVal) annotation (Line(
      points={{-39,30},{-32,30},{-32,16},{-22,16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Control/Example/dPControl.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end dPControl;
