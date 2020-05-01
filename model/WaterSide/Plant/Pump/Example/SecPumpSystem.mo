within WaterSide.Plant.Pump.Example;
model SecPumpSystem
  import WaterSide.Plant.Pump;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate ";
  parameter Modelica.SIunits.Pressure dP_nominal=1000
    "Nominal Pressure difference";
  parameter Real v_flow_ratio[:] = {0,0.5,1};
  parameter Real v_flow_rate[:] = {0,m_flow_nominal/996/2,m_flow_nominal/996};
  parameter Real pressure[:] = {2*dP_nominal,dP_nominal,0};
  parameter Real Motor_eta[:] = {1,1,1} "Motor efficiency";
  parameter Real Hydra_eta[:] = {1,1,1} "Hydraulic efficiency";
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    p=0,
    T=293.15) annotation (Placement(transformation(extent={{-80,-30},{-60,-10}},
          rotation=0)));
  Buildings.Fluid.FixedResistances.PressureDrop       dpDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dP_nominal*0.5) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Ramp SpeedB(
    duration=100,
    height=1,
    startTime=150)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Modelica.Blocks.Sources.Ramp SpeedA(
    duration=100,
    height=1,
    startTime=0)
              annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Pump.SecPumpSystem secPumSys(
    redeclare package Medium = Medium,
    dP_nominal=dP_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    Pressure=pressure,
    N_nominal=1500,
    dPFrihealos_nominal=dP_nominal*0.5,
    m_flow_nominal=m_flow_nominal/2) annotation (Placement(transformation(extent={{-10,-6},
            {24,28}})));
equation

  connect(dpDyn.port_b,senMasFlo. port_a) annotation (Line(
      points={{80,0},{90,0},{90,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senMasFlo.port_b,sou. ports[1]) annotation (Line(
      points={{0,-80},{-60,-80},{-60,-18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(secPumSys.port_b, dpDyn.port_a)
    annotation (Line(
      points={{24,11},{38,11},{38,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(secPumSys.port_a, sou.ports[2])
    annotation (Line(
      points={{-10,11},{-60,11},{-60,-22}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(SpeedA.y, secPumSys.Spe[1]) annotation (Line(
      points={{-59,30},{-40,30},{-40,20.435},{-11.53,20.435}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(SpeedB.y, secPumSys.Spe[2]) annotation (Line(
      points={{-59,70},{-36,70},{-36,21.965},{-11.53,21.965}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/Pump/Example/SecPumpSystem.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=500),
    __Dymola_experimentSetupOutput);
end SecPumpSystem;
