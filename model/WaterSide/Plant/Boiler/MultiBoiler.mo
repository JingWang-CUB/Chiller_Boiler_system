within WaterSide.Plant.Boiler;
model MultiBoiler
  replaceable package MediumHW =
     Buildings.Media.Water
    "Medium in the hot water side";
  parameter Modelica.SIunits.Pressure dPHW_nominal
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.MassFlowRate mHW_flow_nominal
    "Nominal mass flow rate at the chilled water side";
  parameter Modelica.SIunits.Temperature THW
    "The start temperature of chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTHW_nominal
    "Temperature difference between the outlet and inlet of the module";
  parameter Real GaiPi "Gain of the component PI controller";
  parameter Real tIntPi "Integration time of the component PI controller";
  parameter Real eta[:] "Fan efficiency";
  Modelica.Blocks.Interfaces.RealInput On[2](min=0,max=1) "On signal"    annotation (Placement(transformation(extent={{-118,
            -31},{-100,-49}})));
  Modelica.Blocks.Interfaces.RealInput THWSet
    "Temperature setpoint of the chilled water"
    annotation (Placement(transformation(extent={{-118,31},{-100,49}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_HW(redeclare package Medium =
        MediumHW)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
        iconTransformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_HW(redeclare package Medium =
        MediumHW)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHWEntChi(
    allowFlowReversal=true,
    redeclare package Medium = MediumHW,
    m_flow_nominal=2*mHW_flow_nominal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHWLeaChi(
    allowFlowReversal=true,
    redeclare package Medium = MediumHW,
    m_flow_nominal=2*mHW_flow_nominal,
    T_start=THW) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={52,-80})));
  Modelica.Blocks.Interfaces.RealOutput Rat[2] "compressor speed ratio"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  BaseClasses.Components.Boiler boi1(
    redeclare package MediumHW = MediumHW,
    dPHW_nominal=dPHW_nominal,
    mHW_flow_nominal=mHW_flow_nominal,
    THW=THW,
    dTHW_nominal=dTHW_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    eta=eta) annotation (Placement(transformation(extent={{-14,4},{6,24}})));
  BaseClasses.Components.Boiler boi2(
    redeclare package MediumHW = MediumHW,
    dPHW_nominal=dPHW_nominal,
    mHW_flow_nominal=mHW_flow_nominal,
    THW=THW,
    dTHW_nominal=dTHW_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    eta=eta,
    boi(T_nominal(displayUnit="K")))
             annotation (Placement(transformation(extent={{-14,-46},{6,-26}})));
equation
  connect(senTHWEntChi.port_a, port_a_HW) annotation (Line(
      points={{60,80},{100,80}},
      color={255,0,0},
      thickness=1));
  connect(senTHWLeaChi.port_b, port_b_HW) annotation (Line(
      points={{62,-80},{100,-80}},
      color={255,0,0},
      thickness=1));
  connect(port_b_HW, port_b_HW) annotation (Line(
      points={{100,-80},{100,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTHWEntChi.port_b, boi1.port_a_HW) annotation (Line(
      points={{40,80},{28,80},{6,80},{6,22}},
      color={255,0,0},
      thickness=1));
  connect(boi2.port_a_HW, boi1.port_a_HW) annotation (Line(
      points={{6,-28},{22,-28},{22,80},{6,80},{6,22}},
      color={255,0,0},
      thickness=1));
  connect(boi1.port_b_CHW, senTHWLeaChi.port_a) annotation (Line(
      points={{6,6},{20,6},{34,6},{34,-80},{42,-80}},
      color={255,0,0},
      thickness=1));
  connect(boi2.port_b_CHW, senTHWLeaChi.port_a) annotation (Line(
      points={{6,-44},{6,-44},{6,-80},{42,-80}},
      color={255,0,0},
      thickness=1));
  connect(THWSet, boi1.THWSet) annotation (Line(
      points={{-109,40},{-76,40},{-38,40},{-38,17},{-16,17}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(boi2.THWSet, boi1.THWSet) annotation (Line(
      points={{-16,-33},{-38,-33},{-38,17},{-16,17}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(boi1.On, On[1]) annotation (Line(
      points={{-16,9},{-78,9},{-78,-35.5},{-109,-35.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(boi2.On, On[2]) annotation (Line(
      points={{-16,-41},{-61,-41},{-61,-44.5},{-109,-44.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Rat, On) annotation (Line(
      points={{110,-40},{-109,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-28,80},{26,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,-40},{26,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,-80},{102,-80}},
          color={255,0,0}),
        Line(
          points={{40,-80},{40,50},{26,50}},
          color={255,0,0}),
        Line(
          points={{26,-70},{40,-70}},
          color={255,0,0}),
        Line(
          points={{26,-48},{60,-48},{60,80}},
          color={255,0,0}),
        Line(
          points={{100,80},{60,80}},
          color={255,0,0}),
        Line(
          points={{26,72},{60,72}},
          color={255,0,0}),
        Ellipse(
          extent={{20,56},{30,44}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,54},{28,46}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-64},{30,-76}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,-66},{28,-74}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,78},{30,66}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-44},{30,-56}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end MultiBoiler;
