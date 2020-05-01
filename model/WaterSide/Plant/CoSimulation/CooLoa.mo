within WaterSide.Plant.CoSimulation;
model CooLoa
  parameter Real tsta;
  parameter Real tend;
  building_fmu_fmu building_fmu_fmu1(
    fmi_StartTime=tsta,
    fmi_StopTime=tend,
    fmi_NumberOfSteps=(tend - tsta)/60)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Interfaces.RealInput CHW_temp "IDF line 10134"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{52,20},{72,40}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{28,-56},{48,-36}})));
  Modelica.Blocks.Interfaces.RealOutput Loa "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Gain gain(k=4200)
    annotation (Placement(transformation(extent={{80,26},{88,34}})));
  Modelica.Blocks.Interfaces.RealOutput TOutWetBul "IDF line 10136"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
  connect(building_fmu_fmu1.CHW_temp, CHW_temp)
    annotation (Line(points={{-12.4,0},{-120,0}}, color={0,0,127}));
  connect(add.u1, building_fmu_fmu1.T_out) annotation (Line(points={{26,-40},{
          18,-40},{18,4.3},{9,4.3}},
                               color={0,0,127}));
  connect(add.u2, building_fmu_fmu1.T_in) annotation (Line(points={{26,-52},{14,
          -52},{14,7.2},{9,7.2}},
                               color={0,0,127}));
  connect(building_fmu_fmu1.m, product.u1) annotation (Line(points={{9,1.5},{38,
          1.5},{38,36},{50,36}},color={0,0,127}));
  connect(add.y, product.u2) annotation (Line(points={{49,-46},{60,-46},{60,10},
          {46,10},{46,24},{50,24}}, color={0,0,127}));
  connect(product.y, gain.u)
    annotation (Line(points={{73,30},{75.8,30},{79.2,30}}, color={0,0,127}));
  connect(gain.y, Loa) annotation (Line(points={{88.4,30},{96,30},{96,0},{110,0}},
        color={0,0,127}));
  connect(building_fmu_fmu1.TOutWetBul, TOutWetBul) annotation (Line(points={{9,
          -7.1},{80,-7.1},{80,-40},{110,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end CooLoa;
