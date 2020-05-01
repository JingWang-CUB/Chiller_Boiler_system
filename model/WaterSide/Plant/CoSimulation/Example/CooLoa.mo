within WaterSide.Plant.CoSimulation.Example;
model CooLoa
  import WaterSideSystem = WaterSide;
  extends Modelica.Icons.Example;
  WaterSideSystem.Plant.CoSimulation.CooLoa cooLoa(tsta=150*86400, tend=151*
        86400)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const(k=5.56)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(const.y, cooLoa.CHW_temp)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=1.296e+007,
      StopTime=1.30464e+007,
      __Dymola_NumberOfIntervals=1440));
end CooLoa;
