within WaterSide.Plant.CoSimulation.Example;
model HeaLoa
  import WaterSideSystem = WaterSide;
  extends Modelica.Icons.Example;
  WaterSideSystem.Plant.CoSimulation.HeaLoa heaLoa(tsta=30*86400, tend=31*86400)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const(k=80)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(const.y, heaLoa.HW_temp)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=2.592e+006,
      StopTime=2.6784e+006,
      __Dymola_NumberOfIntervals=1440));
end HeaLoa;
