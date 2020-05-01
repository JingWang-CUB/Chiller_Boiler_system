within WaterSide.BaseClasses.Components;
model PumpConstantSpeed
  "Constant Speed Pump such as primary chilled water pump and condenser water pump"
  replaceable package Medium =
            Buildings.Media.Water "Medium water";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate ";
    parameter Real Motor_eta "Motor efficiency";
    parameter Real Hydra_eta "Hydraulic efficiency";
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                            Pum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    allowFlowReversal=true,
    per(hydraulicEfficiency(eta={Hydra_eta}), motorEfficiency(eta={Motor_eta})))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput P "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Interfaces.RealInput On(min=0,max=1) "On signal"    annotation (Placement(transformation(extent={{-118,51},
            {-100,69}})));
equation
  connect(Pum.port_a, port_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(Pum.port_b, port_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(port_b, port_b) annotation (Line(
      points={{100,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(Pum.P, P) annotation (Line(
      points={{11,9},{60,9},{60,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gain.u, On) annotation (Line(
      points={{-62,60},{-109,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gain.y,Pum. m_flow_in)
    annotation (Line(
      points={{-39,60},{0,60},{0,12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-40,-100},{46,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,0},{-8,-12},{-8,10},{16,0}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-98,0},{-20,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{20,0},{98,0}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PumpConstantSpeed;
