# Product Origin Scanner

## Overview
Product Origin Scanner is a mobile application designed to identify the manufacturing origin of consumer goods. By scanning a product's EAN-13 barcode, the system retrieves supply chain data, prioritizing the identification of domestically produced items.

## Core Features
*   **Real-time Scanning:** Hardware-accelerated barcode decoding via device camera.
*   **Data Aggregation:** Queries the Open Food Facts REST API for ingredient origin, manufacturing facility data, and traceability.
*   **GS1 Prefix Analysis:** Fallback logic to determine the distributor's registered country via the EAN prefix (e.g., 84 for GS1 Spain).
*   **UI/UX:** Native dark mode default for optimal low-light visibility and interface consistency.

## Tech Stack
*   **Client:** Flutter / Dart
*   **Middleware:** Node.js, TypeScript
*   **External API:** Open Food Facts (v2)

## Architecture
The system follows a clean architecture model separating the UI layer, the domain logic for origin resolution, and the data layer responsible for API communication and local caching.

## Contributing
Ensure all pull requests adhere to the established linting rules and pass the core test suite before requesting a review.
