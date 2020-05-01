within WaterSide.BaseClasses.Control;
model BoilerStage "Stage controller for pumps"
  parameter Real tWai "Waiting time";
  parameter Real HeaCap "Normal Heating Capacity";

  Modelica.Blocks.Interfaces.RealOutput y[2](min=0, max=2)
    "Output of stage control"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.StepWithSignal
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
  Modelica.StateGraph.InitialStepWithSignal
                                     OneOn(       nOut=2, nIn=3)
                                                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,22})));
  Modelica.StateGraph.StepWithSignal TwoOn(       nOut=2, nIn=1)
                                                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-60})));
  Modelica.StateGraph.Transition Off2One(condition=On,
    waitTime=1,
    enableTimer=false)                                 annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,44})));
  Modelica.StateGraph.Transition One2Two(
    enableTimer=true,
    waitTime=tWai,
    condition=PLR1.y > 0.9 and OneOn.active)
                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,-20})));
  Modelica.StateGraph.Transition Two2One(
    enableTimer=true,
    condition=(PLR1.y < 0.35 and PLR2.y < 0.35 and TwoOn.active),
    waitTime=tWai)             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={54,6})));
  Modelica.StateGraph.Transition One2Off(condition=not On)                                     annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={52,48})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-74,70},{-54,90}})));
  MultiSwitch                      multiSwitch1(
    nu=3, expr={0,1,2})
    annotation (Placement(transformation(extent={{60,-34},{76,-14}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(table=[0,0,0; 1,1,0; 2,1,1;
        3,1,1])
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Modelica.Blocks.Sources.RealExpression PLR1(y=-HeaLoa/HeaCap/(Status[1] +
        Status[2]))
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.RealExpression PLR2(y=if Status[2] > 0 then -HeaLoa/2/
        HeaCap else 0)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Interfaces.RealInput HeaLoa "Calculated heating load"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.StateGraph.Transition Two2OneOff(
    condition=not On) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={84,16})));
equation
  connect(AllOff.outPort[1], Off2One.inPort) annotation (Line(points={{0,59.5},
          {0,59.5},{0,54},{0,52},{-50,52},{-50,48}}, color={0,0,0}));
  connect(Off2One.outPort, OneOn.inPort[1]) annotation (Line(points={{-50,42.5},
          {-50,36},{-0.666667,36},{-0.666667,33}},
                                         color={0,0,0}));
  connect(OneOn.outPort[1], One2Two.inPort) annotation (Line(points={{-0.25,
          11.5},{-0.25,-10},{-50,-10},{-50,-16}},
                                      color={0,0,0}));
  connect(One2Two.outPort, TwoOn.inPort[1]) annotation (Line(points={{-50,-21.5},
          {-50,-40},{0,-40},{0,-44},{6.66134e-016,-44},{6.66134e-016,-49}},
                                         color={0,0,0}));
  connect(Two2One.outPort, OneOn.inPort[2]) annotation (Line(points={{54,7.5},{
          54,7.5},{54,32},{7.21645e-016,32},{7.21645e-016,33}},
                                              color={0,0,0}));
  connect(One2Off.outPort, AllOff.inPort[1]) annotation (Line(points={{52,49.5},
          {52,49.5},{52,86},{52,88},{1.9984e-015,88},{1.9984e-015,81}}, color={
          0,0,0}));
  connect(OneOn.outPort[2], One2Off.inPort) annotation (Line(points={{0.25,11.5},
          {2,11.5},{2,-10},{30,-10},{30,28},{52,28},{52,44}},
                                                         color={0,0,0}));
  connect(AllOff.active, multiSwitch1.u[1]) annotation (Line(points={{11,70},{
          36,70},{36,-22},{60,-22}}, color={255,0,255}));
  connect(OneOn.active, multiSwitch1.u[2]) annotation (Line(points={{11,22},{18,
          22},{30,22},{30,-24},{60,-24}}, color={255,0,255}));
  connect(TwoOn.active, multiSwitch1.u[3]) annotation (Line(points={{11,-60},{11,
          -60},{40,-60},{40,-26},{60,-26}},    color={255,0,255}));
  connect(multiSwitch1.y, combiTable1D.u) annotation (Line(points={{76.4,-24},{
          80,-24},{80,-40},{60,-40},{60,-60},{68,-60}}, color={0,0,127}));
  connect(combiTable1D.y, y) annotation (Line(points={{91,-60},{96,-60},{96,0},
          {110,0}}, color={0,0,127}));
  connect(Two2OneOff.outPort, OneOn.inPort[3]) annotation (Line(points={{84,17.5},
          {84,38},{0.666667,38},{0.666667,33}}, color={0,0,0}));
  connect(TwoOn.outPort[1], Two2One.inPort) annotation (Line(points={{-0.25,
          -70.5},{-2,-70.5},{-2,-96},{-2,-94},{54,-94},{54,2}}, color={0,0,0}));
  connect(Two2OneOff.inPort, TwoOn.outPort[2]) annotation (Line(points={{84,12},
          {84,12},{84,-30},{24,-30},{24,-80},{0.25,-80},{0.25,-70.5}}, color={0,
          0,0}));
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
end BoilerStage;
