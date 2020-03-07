within WaterSideSystem.BaseClasses.Control;
model TwoStage "Stage controller for pumps"
  parameter Real tWai "Waiting time";
  Modelica.Blocks.Interfaces.RealOutput y[2](min=0, max=2)
    "Output of stage control"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.InitialStepWithSignal
                            AllOff(
    nOut=1, nIn=1)
           "Both of the two compressors are off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,70})));
  Modelica.Blocks.Interfaces.BooleanInput
                                       On "On signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput Status[2]
    "Temperature setpoint of chilled wate leaving chiller plant"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.StateGraph.StepWithSignal OneOn(nIn=2, nOut=2) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,18})));
  Modelica.StateGraph.StepWithSignal TwoOn(nIn=2, nOut=2) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-60})));
  Modelica.StateGraph.Transition Off2One(condition=On) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,44})));
  Modelica.StateGraph.Transition One2Two(
    condition=Status[1] > 0.9,
    enableTimer=true,
    waitTime=tWai) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,-20})));
  Modelica.StateGraph.Transition Two2One(condition=(Status[1] < 0.3 and Status[
        2] < 0.3) or (not On)) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={54,6})));
  Modelica.StateGraph.Transition One2Off(condition=not On) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={52,48})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-74,70},{-54,90}})));
  Modelica.Blocks.Math.MultiSwitch multiSwitch1(
    nu=3, expr={0,1,2})
    annotation (Placement(transformation(extent={{60,-34},{76,-14}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(table=[0,0,0; 1,1,0; 2,1,1;
        3,1,1])
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
equation
  connect(AllOff.outPort[1], Off2One.inPort) annotation (Line(points={{0,59.5},
          {0,59.5},{0,54},{0,52},{-50,52},{-50,48}}, color={0,0,0}));
  connect(Off2One.outPort, OneOn.inPort[1]) annotation (Line(points={{-50,42.5},
          {-50,36},{-0.5,36},{-0.5,29}}, color={0,0,0}));
  connect(OneOn.outPort[1], One2Two.inPort) annotation (Line(points={{-0.25,7.5},
          {-0.25,-10},{-50,-10},{-50,-16}},
                                      color={0,0,0}));
  connect(One2Two.outPort, TwoOn.inPort[1]) annotation (Line(points={{-50,-21.5},
          {-50,-40},{0,-40},{0,-44},{-0.5,-44},{-0.5,-49}},
                                         color={0,0,0}));
  connect(Two2One.outPort, OneOn.inPort[2]) annotation (Line(points={{54,7.5},{
          54,7.5},{54,32},{0.5,32},{0.5,29}}, color={0,0,0}));
  connect(One2Off.outPort, AllOff.inPort[1]) annotation (Line(points={{52,49.5},
          {52,49.5},{52,86},{52,88},{1.9984e-015,88},{1.9984e-015,81}}, color={
          0,0,0}));
  connect(OneOn.outPort[2], One2Off.inPort) annotation (Line(points={{0.25,7.5},
          {2,7.5},{2,-10},{30,-10},{30,28},{52,28},{52,44}},
                                                         color={0,0,0}));
  connect(Two2One.inPort, TwoOn.outPort[2]) annotation (Line(points={{54,2},{54,
          -92},{0.25,-92},{0.25,-70.5}}, color={0,0,0}));
  connect(AllOff.active, multiSwitch1.u[1]) annotation (Line(points={{11,70},{
          36,70},{36,-22},{60,-22}}, color={255,0,255}));
  connect(OneOn.active, multiSwitch1.u[2]) annotation (Line(points={{11,18},{18,
          18},{30,18},{30,-24},{60,-24}}, color={255,0,255}));
  connect(TwoOn.active, multiSwitch1.u[3]) annotation (Line(points={{11,-60},{
          28,-60},{40,-60},{40,-26},{60,-26}}, color={255,0,255}));
  connect(multiSwitch1.y, combiTable1D.u) annotation (Line(points={{76.4,-24},{
          80,-24},{80,-40},{60,-40},{60,-60},{68,-60}}, color={0,0,127}));
  connect(combiTable1D.y, y) annotation (Line(points={{91,-60},{96,-60},{96,0},
          {110,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,42},{58,-42}},
          lineColor={0,0,255},
          textString="CompressorStage"),
        Text(
          extent={{-44,-144},{50,-112}},
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
end TwoStage;
