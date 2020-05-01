within WaterSide.BaseClasses.Control.Example;
model PumpStage

  import ChillerPlantSystem = WaterSide;
  extends Modelica.Icons.Example;
  parameter Real tWai = 300 "Waiting time";

  ChillerPlantSystem.BaseClasses.Control.TwoStage comSta(tWai=tWai)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine s1(
    freqHz=1/3600/24,
    amplitude=0.5,
    offset=0.5)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Step On(
    height=-1,
    offset=1,
    startTime=80000)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-24,60},{-4,80}})));
  Modelica.Blocks.Sources.Sine s2(
    freqHz=1/3600/24,
    amplitude=0.5,
    offset=0.5,
    startTime=2400)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation

  connect(On.y, realToBoolean.u)
    annotation (Line(points={{-39,70},{-32.5,70},{-26,70}}, color={0,0,127}));
  connect(realToBoolean.y, comSta.On) annotation (Line(points={{-3,70},{18,70},
          {18,26},{-28,26},{-28,8},{-12,8}}, color={255,0,255}));
  connect(s2.y, comSta.Status[2]) annotation (Line(points={{-59,-50},{-22,-50},
          {-22,-7},{-12,-7}}, color={0,0,127}));
  connect(s1.y, comSta.Status[1]) annotation (Line(points={{-59,-10},{-36,-10},
          {-36,-9},{-12,-9}}, color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Control/Example/CompressorStage.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model is designed to test how the stage works when the measured T changes by time(Sine function).</p>
</html>"));
end PumpStage;
