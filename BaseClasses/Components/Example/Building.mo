within WaterSideSystem.BaseClasses.Components.Example;
model Building

  import ChillerPlantSystem = WaterSideSystem;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate ";
  parameter Modelica.SIunits.Pressure dP_nominal=1000
    "Nominal Pressure difference";
  parameter Real v_flow_ratio[:] = {0,0.5,1};
  parameter Real v_flow_rate[:] = {0,m_flow_nominal/996,2*m_flow_nominal/996};
  parameter Real pressure[:] = {2*dP_nominal,dP_nominal,0};
  parameter Real Motor_eta[:] = {1,1,1} "Motor efficiency";
  parameter Real Hydra_eta[:] = {1,1,1} "Hydraulic efficiency";
  ChillerPlantSystem.BaseClasses.Components.Building
                                         bui(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tIntPi=60,
    GaiPi=0.1,
    dP_nominal=dP_nominal*0.999,
    TBuiSetPoi=273.15 + 11.12)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed
                                                pumVarSpe(
    m_flow_nominal=m_flow_nominal,
    dP_nominal=dP_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    Pressure=pressure,
    N_nominal=1500,
    redeclare package Medium = Medium,
    dPFrihealos_nominal=dP_nominal*0.001)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    p=0,
    T(displayUnit="K") = 273.15 + 5.56)
                                 annotation (Placement(transformation(extent={{
            -90,-12},{-70,8}}, rotation=0)));
  Modelica.Blocks.Sources.Constant On(k=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp CooLoa(
    height=4200*m_flow_nominal*5,
    duration=18000,
    startTime=0)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
equation

  connect(sou.ports[1], pumVarSpe.port_a) annotation (Line(
      points={{-70,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumVarSpe.port_b, bui.port_a) annotation (Line(
      points={{-20,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(bui.port_b, sou.ports[2]) annotation (Line(
      points={{40,0},{60,0},{60,-40},{-60,-40},{-60,-4},{-70,-4}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(On.y, pumVarSpe.Spe) annotation (Line(
      points={{-59,70},{-50,70},{-50,6},{-42,6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(CooLoa.y, bui.CooLoa) annotation (Line(
      points={{1,70},{10,70},{10,4},{19.1,4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Components/Example/Building.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics),
    experiment(StopTime=21600),
    __Dymola_experimentSetupOutput);
end Building;
