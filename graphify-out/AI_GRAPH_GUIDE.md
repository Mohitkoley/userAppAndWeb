# AI Graph Guide

Generated on 2026-05-10 for `/Users/mohitkoley/flutter_projects/freelance/oleyshop/userAppAndWeb`.

## What Exists

- `graph.json`: GraphRAG-ready JSON with 2,818 nodes and 5,405 edges.
- `GRAPH_REPORT.md`: readable audit report with god nodes, communities, and suggested questions.
- `graph.html`: interactive graph visualization; open directly in a browser.
- `manifest.json`: file manifest for future incremental updates.
- `cost.json`: extraction token accounting.

## Scope And Limits

This graph was built with deterministic AST/source extraction. It covers code structure and imports across the Flutter project and native platform files. It does not include semantic LLM extraction for screenshots, images, videos, or prose rationale.

Detected corpus at build time:

- 578 supported files
- About 349,302 words
- 370 code files
- 7 document files
- 199 image files
- 2 video/audio files
- 3 sensitive files skipped by graphify detection

## Query Commands

```bash
graphify query "what are the core abstractions" --graph graphify-out/graph.json
graphify query "what connects the data layer to the api" --graph graphify-out/graph.json
graphify query "how are errors handled" --graph graphify-out/graph.json
graphify explain "package:flutter_grocery/helper/route_helper.dart" --graph graphify-out/graph.json
graphify path "package:flutter_grocery/features/auth/providers/auth_provider.dart" "package:flutter_grocery/data/datasource/remote/dio/dio_client.dart" --graph graphify-out/graph.json
```

## Refresh Commands

For code-only changes:

```bash
graphify update .
```

For a richer future graph with semantic edges from docs, images, and videos, rerun graphify with a semantic-capable agent workflow or an LLM backend, then regenerate `graph.json`, `GRAPH_REPORT.md`, and `graph.html`.

## Current High-Value Hubs

- `package:flutter/material.dart`
- `package:flutter_grocery/utill/dimensions.dart`
- `package:provider/provider.dart`
- `package:flutter_grocery/utill/styles.dart`
- `package:flutter_grocery/localization/language_constraints.dart`
- `package:flutter_grocery/helper/responsive_helper.dart`
- `package:flutter_grocery/features/splash/providers/splash_provider.dart`
- `package:flutter_grocery/helper/route_helper.dart`
- `package:flutter_grocery/utill/images.dart`
- `package:flutter_grocery/helper/custom_snackbar_helper.dart`
