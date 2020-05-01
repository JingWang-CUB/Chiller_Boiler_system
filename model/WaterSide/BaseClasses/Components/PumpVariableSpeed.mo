within WaterSide.BaseClasses.Components;
model PumpVariableSpeed
  "Variable Speed Pump such as secondary chilled water pump"
  replaceable package Medium =
      Buildings.Media.Water "Medium water";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate ";
    parameter Modelica.SIunits.Pressure dP_nominal
    "Nominal Pressure difference";
    parameter Modelica.SIunits.Pressure dPFrihealos_nominal
    "Frictional head loss";
    parameter Real v_flow_ratio[:] "Volume flow rate ratio";
    parameter Real v_flow_rate[:] "Volume flow rate rate";
    parameter Real Motor_eta[:] "Motor efficiency";
    parameter Real Hydra_eta[:] "Hydraulic efficiency";
    parameter Real Pressure[:] "Pressure at different flow rate";
    parameter Real N_nominal "Nominal speed";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electrical power consumed by the pump"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    "Mass flow rate from port_a to port_b"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealInput Spe "Speed signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Math.Gain gain(k=N_nominal)      annotation (Placement(transformation(extent={{-58,50},
            {-38,70}})));
  Modelica.Blocks.Interfaces.RealOutput SpeRat
    "Speed of the pump divided by the nominal value"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Fluid.Movers.SpeedControlled_Nrpm
                                          pum(
    redeclare package Medium = Medium,
    addPowerToMedium=false,
    allowFlowReversal=true,
    riseTime=30,
    per(
      pressure(V_flow=v_flow_rate, dp=Pressure),
      hydraulicEfficiency(V_flow=v_flow_rate, eta=Hydra_eta),
      motorEfficiency(V_flow=v_flow_rate, eta=Motor_eta)))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dpValve_nominal=dPFrihealos_nominal,
    allowFlowReversal=false,
    l=0.0001,
    riseTime=120)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if Spe > 0.001 then 1
         else 0)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  connect(pum.P, P) annotation (Line(
      points={{11,9},{20,9},{20,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pum.port_a, senMasFlo.port_b) annotation (Line(
      points={{-10,0},{-48,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senMasFlo.m_flow, m_flow) annotation (Line(
      points={{-58,11},{-58,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(gain.u, Spe) annotation (Line(
      points={{-60,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(SpeRat, Spe) annotation (Line(
      points={{110,80},{-80,80},{-80,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senMasFlo.port_a, port_a) annotation (Line(
      points={{-68,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pum.port_b, val.port_a) annotation (Line(
      points={{10,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(val.port_b, port_b) annotation (Line(
      points={{60,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(realExpression.y, val.y) annotation (Line(
      points={{41,60},{50,60},{50,12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gain.y, pum.Nrpm) annotation (Line(
      points={{-37,60},{-18,60},{0,60},{0,12}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-64,54},{70,-52}},
          lineColor={0,0,255},
          textString="PumpVariableSpeed"),
        Text(
          extent={{-38,-100},{48,-154}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PumpVariableSpeed;
