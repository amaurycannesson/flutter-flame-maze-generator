class Graph {
  final _graph = new Map<Vertex, List<Vertex>>();

  static Graph generate(int size) {
    final graph = Graph();

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (j + 1 < size) graph.addEdge(Edge(Vertex(Pos(j, i)), Vertex(Pos(j + 1, i))));
        if (i + 1 < size) graph.addEdge(Edge(Vertex(Pos(j, i)), Vertex(Pos(j, i + 1))));
        if (j - 1 >= 0) graph.addEdge(Edge(Vertex(Pos(j, i)), Vertex(Pos(j - 1, i))));
        if (i - 1 >= 0) graph.addEdge(Edge(Vertex(Pos(j, i)), Vertex(Pos(j, i - 1))));
      }
    }

    return graph;
  }

  Iterable<Edge> dfs({Vertex vertex = const Vertex(Pos(0, 0))}) sync* {
    List<Vertex> visitedVertices = [];
    List<Edge> queue = List.from([Edge(vertex, vertex)]);

    while (queue.isNotEmpty) {
      var edge = queue.removeLast();
      var vertex = edge.dest;

      if (!visitedVertices.contains(vertex)) {
        yield edge;
        visitedVertices.add(vertex);

        List<Edge> neighbors = [];
        for (var neighbor in _graph[vertex]!) {
          if (!visitedVertices.contains(neighbor)) {
            neighbors.add(Edge(vertex, neighbor));
          }
        }

        neighbors.shuffle();
        queue.addAll(neighbors);
      }
    }
  }

  void addEdge(Edge edge) {
    _graph.update(
      edge.source,
      (neighbors) => !neighbors.contains(edge.dest) ? (neighbors..add(edge.dest)) : neighbors,
      ifAbsent: () => [edge.dest],
    );
    _graph.update(
      edge.dest,
      (neighbors) => !neighbors.contains(edge.source) ? (neighbors..add(edge.source)) : neighbors,
      ifAbsent: () => [edge.source],
    );
  }
}

class Edge {
  final Vertex source;
  final Vertex dest;

  const Edge(this.source, this.dest);

  @override
  String toString() => '$source -> $dest';

  @override
  bool operator ==(other) => other.hashCode == hashCode;

  @override
  int get hashCode => this.toString().hashCode;
}

class Vertex {
  final Pos pos;

  const Vertex(this.pos);

  Pos get mapPos => Pos(pos.x * 2 + 1, pos.y * 2 + 1);

  @override
  String toString() => '$pos';

  @override
  bool operator ==(other) => other.hashCode == hashCode;

  @override
  int get hashCode => this.toString().hashCode;
}

class Pos {
  final int x;
  final int y;

  const Pos(this.x, this.y);

  @override
  String toString() => '( $x, $y )';

  @override
  bool operator ==(other) => other.hashCode == hashCode;

  @override
  int get hashCode => this.toString().hashCode;
}
