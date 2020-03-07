within WaterSideSystem.Plant.Pump.Control.Examole;
model SecPumCon
  import WaterSideSystem;
  extends Modelica.Icons.Example;
  WaterSideSystem.Plant.Pump.Control.SecPumCon secPumCon(tWai=300, dPSetPoi(
        displayUnit="Pa") = 478250)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine s1(
    freqHz=1/3600/24,
    amplitude=0.5,
    offset=0.5)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Sine s2(
    freqHz=1/3600/24,
    amplitude=0.5,
    offset=0.5,
    startTime=2400)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.Step On(
    height=-1,
    offset=1,
    startTime=80000)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Modelica.Blocks.Sources.Sine dP(
    freqHz=1/43200,
    amplitude=239125,
    offset=239125)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Step y(
    startTime=43200,
    height=-1,
    offset=1) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(On.y,realToBoolean. u)
    annotation (Line(points={{-59,70},{-59,70},{-52,70}},   color={0,0,127}));
  connect(realToBoolean.y, secPumCon.On) annotation (Line(points={{-29,70},{-24,
          70},{-20,70},{-20,8},{-12,8}}, color={255,0,255}));
  connect(secPumCon.yVal, y.y) annotation (Line(points={{-12,4},{-40,4},{-40,30},
          {-59,30}}, color={0,0,127}));
  connect(dP.y, secPumCon.dP) annotation (Line(points={{-59,-10},{-50,-10},{-50,
          -4},{-12,-4}}, color={0,0,127}));
  connect(s1.y, secPumCon.Status[1]) annotation (Line(points={{-59,-40},{-48,
          -40},{-40,-40},{-40,-9},{-12,-9}}, color={0,0,127}));
  connect(s2.y, secPumCon.Status[2]) annotation (Line(points={{-59,-80},{-28,
          -80},{-28,-7},{-12,-7}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SecPumCon;
