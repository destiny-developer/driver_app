class RouteArgument {
  String? id;
  String? heroTag;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param});

  @override
  String toString() => '{id: $id, heroTag:${heroTag.toString()}}';
}
