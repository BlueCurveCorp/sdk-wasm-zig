# BlueCurve Zig WASM SDK

CI publishes this SDK at <https://github.com/BlueCurveCorp/sdk-wasm-zig> under immutable `v<GitVersion SemVer>` tags.
Install a published version with `zig fetch --save=bluecurve <tag-archive-url>`, using the GitHub tag's `.tar.gz` source archive.
The archive contains the `bluecurve` module, manifest, and BlueCurve Proprietary SDK License.

Use Zig 0.15.2 and import the `bluecurve` build module. File plugins export `index_file`; job plugins export `start_job`.
Both export `memory`, `alloc` and `dealloc`. The repository's guest fixtures build with
`zig build -Dtarget=wasm32-freestanding -Doptimize=ReleaseSmall`.

Fingerprint imports write all 128 bits into a 16-byte little-endian output buffer. Rebuild plugins with this SDK;
old two-argument fingerprint imports are incompatible. Prefer `computeFingerprint*` helpers over raw host calls.

File and job field writers grow with their contents, including str32/bin32 payloads above 64 KiB.
KPI writers preserve string literals, byte slices, integer/float values, booleans and null;
unsupported value types fail compilation. Parameter counts above 15 use MessagePack array16/array32 headers.
State and repository metadata buffers grow on host result `-2`. Returned slices belong to the supplied allocator;
the caller must free them. `null` means missing data (`-1`); invalid lengths return errors.

Run `zig build test` for serialization and buffer regressions. The repository's `BlueCurve.Search.Sdk.Wasm.Tests`
project also executes real Zig file and job guests. See `docs/sdk/README.md` in the BlueCurve repository for the shared ABI.
