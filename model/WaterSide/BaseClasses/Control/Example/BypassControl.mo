within WaterSide.BaseClasses.Control.Example;
model BypassControl

  import ChillerPlantSystem = WaterSide;
    extends Modelica.Icons.Example;
  ChillerPlantSystem.BaseClasses.Control.BypassControl
                                    bypCon(TSet(displayUnit="K") = 273.15 +
      15.56)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Sine T(
    offset=273.15 + 15.56,
    freqHz=1/43200,
    amplitude=2)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation

  connect(T.y, bypCon.T) annotation (Line(
      points={{-39,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Control/Example/BypassControl.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    experiment(StopTime=129600),
    __Dymola_experimentSetupOutput);
end BypassControl;
