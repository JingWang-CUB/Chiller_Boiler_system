within WaterSide.BaseClasses.Components.Example;
model Compressor
  import ChillerPlantSystem = WaterSide;
  extends Modelica.Icons.Example;
 package MediumCHW = Buildings.Media.Water "Medium model";
 package MediumCW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Power P_nominal = 756E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference
                                           dTCHW_nominal = 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.TemperatureDifference
                                           dTCW_nominal = 5.18
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.Pressure dPCHW_nominal = 6000
    "Pressure difference at chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal = 6000
    "Pressure difference at condenser water wide";
  parameter Modelica.SIunits.Temperature TCHW_nominal = 273.15 + 5.56
    "Temperature at chilled water side";
  parameter Modelica.SIunits.Temperature TCW_nominal = 273.15 + 29.44
    "Temperature at condenser water wide";
  parameter Real COP_nominal = 5.86 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = P_nominal*COP_nominal/dTCHW_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = mCHW_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";
  parameter Real ChillerCurve[:] = {1}
    "Chiller operation Curve(need p(a=ChillerCurve, y=1)=1)";
  parameter Real k = 1 "Gain of the PID controller";
  parameter Real Ti = 60 "Integration time of the PID controller";

  ChillerPlantSystem.BaseClasses.Components.Compressor
                                                   com(
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start(displayUnit="K") = 273.15 + 29.44,
    TCHW_start=273.15 + 5.56,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes()) "Compressor"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souCW(
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = MediumCW,
    T=273.15 + 29.44,
    m_flow=mCW_flow_nominal) "Source for CW"
    annotation (Placement(transformation(extent={{-48,-90},{-28,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCHW(
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=273.15 + 11.11,
    m_flow=mCHW_flow_nominal) "Source for CHW"
    annotation (Placement(transformation(extent={{48,10},{28,30}})));
  Buildings.Fluid.Sources.Boundary_pT   sinCW(nPorts=1, redeclare package
      Medium =         MediumCW) "Sink for CW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-20})));
  Buildings.Fluid.Sources.Boundary_pT   sinCHW(nPorts=1,
      redeclare package Medium = MediumCHW) "Sink for CHW" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-28})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 5.56)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant TCWEntcom(k=273.15 + 29.44)
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
  Modelica.Blocks.Sources.Sine TCHWEntcom(
    freqHz=1/86400,
    amplitude=2.78,
    offset=273.15 + 8.34) annotation (Placement(transformation(extent={{80,14},
            {60,34}})));
  Modelica.Blocks.Sources.Step On(height=1, startTime=3600)
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
equation

  connect(souCW.ports[1], com.port_a_CW) annotation (Line(
      points={{-28,-80},{-20,-80},{-20,-28},{-10,-28}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(souCHW.ports[1], com.port_a_CHW) annotation (Line(
      points={{28,20},{20,20},{20,-12},{10,-12}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(sinCW.ports[1], com.port_b_CW) annotation (Line(
      points={{-60,-20},{-36,-20},{-36,-12},{-10,-12}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(sinCHW.ports[1], com.port_b_CHW) annotation (Line(
      points={{60,-28},{10,-28}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TCHWSet.y, com.TCHWSet) annotation (Line(
      points={{-59,70},{-20,70},{-20,-17},{-12,-17}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCWEntcom.y, souCW.T_in) annotation (Line(
      points={{-59,-76},{-50,-76}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCHWEntcom.y, souCHW.T_in) annotation (Line(
      points={{59,24},{50,24}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(On.y, com.On) annotation (Line(
      points={{-59,32},{-54,32},{-54,-26},{-48,-26},{-48,-25},{-12,-25}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Components/Example/Compressor.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This model is designed to test how the compressor module works under different load condition. In this test, the temperature of condenser water entering the compressor is fixed as 29.44 C while the temperature of chilled water would be changed by time(sine function).</p>
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),            graphics),
    experiment(StartTime=1.62981e+007, StopTime=1.70751e+007),
    __Dymola_experimentSetupOutput);
end Compressor;
