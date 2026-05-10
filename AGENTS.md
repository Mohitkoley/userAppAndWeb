# Project Knowledge Graph

This repository has a durable project knowledge graph in `graphify-out/`.

Start here when you need architecture context:

- `graphify-out/GRAPH_REPORT.md` - human-readable audit report and key hubs.
- `graphify-out/graph.json` - GraphRAG-ready graph data.
- `graphify-out/graph.html` - interactive browser visualization.
- `graphify-out/AI_GRAPH_GUIDE.md` - agent usage notes and refresh commands.

Useful commands:

```bash
graphify query "how does authentication work" --graph graphify-out/graph.json
graphify explain "package:flutter_grocery/helper/route_helper.dart" --graph graphify-out/graph.json
graphify path "package:flutter_grocery/features/auth/providers/auth_provider.dart" "package:flutter_grocery/data/datasource/remote/dio/dio_client.dart" --graph graphify-out/graph.json
```

Current graph scope: deterministic source-code structure for the Flutter app, platform projects, config, docs, and assets detected by graphify. Semantic extraction for docs/images/videos was intentionally not run in this session, so the graph is strongest for code imports, shared architecture, and source navigation.
