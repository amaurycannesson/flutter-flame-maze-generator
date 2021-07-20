import 'graph.dart';

const int lowBrickTile = 43;
const int highBrickTile = 37;
const int lowGrassTile = 7;
const int lowConcreteTile = 25;
const Pos startPos = const Pos(1, 0);

class Maze {
  late final List<List<int>> map;
  late final Iterator updates;

  Maze.generate({int size = 41}) {
    map = List.generate(size, (index) => List.filled(size, highBrickTile));

    final endPos = Pos(size - 1, size - 2);
    map[startPos.y][startPos.x] = lowBrickTile;
    map[endPos.y][endPos.x] = lowBrickTile;

    final graph = Graph.generate((size - 1) ~/ 2);
    updates = graph
        .dfs()
        .map((edge) {
          var vertexUpdate = [edge.dest.mapPos.y, edge.dest.mapPos.x, lowGrassTile];
          var wallUpdate;

          if (edge.dest.pos.x > edge.source.pos.x) {
            wallUpdate = [edge.dest.mapPos.y, edge.dest.mapPos.x - 1, lowGrassTile];
          }
          if (edge.dest.pos.x < edge.source.pos.x) {
            wallUpdate = [edge.dest.mapPos.y, edge.dest.mapPos.x + 1, lowGrassTile];
          }
          if (edge.dest.pos.y > edge.source.pos.y) {
            wallUpdate = [edge.dest.mapPos.y - 1, edge.dest.mapPos.x, lowGrassTile];
          }
          if (edge.dest.pos.y < edge.source.pos.y) {
            wallUpdate = [edge.dest.mapPos.y + 1, edge.dest.mapPos.x, lowGrassTile];
          }

          return wallUpdate != null ? [wallUpdate, vertexUpdate] : [vertexUpdate];
        })
        .expand((u) => u)
        .iterator;
  }

  update() {
    if (updates.moveNext()) {
      map[updates.current[1]][updates.current[0]] = updates.current[2];
    }
  }
}
