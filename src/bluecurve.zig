const std = @import("std");

pub const Host = struct {
    pub extern fn trace_log(level: i32, ptr: [*]const u8, len: i32) void;
    pub extern fn fingerprint_compute_string(ptr: [*]const u8, len: i32, out_ptr: [*]u8) void;
    pub extern fn fingerprint_compute_bytes(ptr: [*]const u8, len: i32, out_ptr: [*]u8) void;
    pub extern fn fingerprint_compute_uri(ptr: [*]const u8, len: i32, out_ptr: [*]u8) void;
    pub extern fn fingerprint_compute_host(ptr: [*]const u8, len: i32, out_ptr: [*]u8) void;
    pub extern fn language_detect(ptr: [*]const u8, len: i32) i32;
    pub extern fn builder_add_field(ptr: [*]const u8, len: i32) void;
    pub extern fn builder_add_language(ptr: [*]const u8, len: i32) void;
    pub extern fn builder_add_creation_date(ticks: i64, offset: i32) void;
    pub extern fn builder_add_modification_date(ticks: i64, offset: i32) void;
    pub extern fn builder_add_collection(ptr: [*]const u8) void;
    pub extern fn builder_add_source(ptr: [*]const u8) void;
    pub extern fn builder_add_markdown(ptr: [*]const u8, len: i32) void;
    pub extern fn builder_add_original_url(ptr: [*]const u8, len: i32) void;
    pub extern fn builder_add_header(k_ptr: [*]const u8, k_len: i32, v_ptr: [*]const u8, v_len: i32) void;
    pub extern fn builder_add_relationship(u_ptr: [*]const u8, u_len: i32, t_ptr: [*]const u8, t_len: i32, ti_ptr: [*]const u8, ti_len: i32, r_type: i32) void;
    pub extern fn builder_build(ptr: [*]const u8, len: i32) void;
    pub extern fn pipeline_post_index(ptr: [*]const u8, len: i32) i32;
    pub extern fn pipeline_post_download(ptr: [*]const u8, len: i32) i32;
    pub extern fn pipeline_delete(ptr: [*]const u8, len: i32) i32;
    pub extern fn repo_get_last_modified(f_low: i64, f_high: i64, u_ptr: [*]const u8) i64;
    pub extern fn repo_find_fetch_metadata_json(f_low: i64, f_high: i64, out_ptr: [*]u8, out_len: i32) i32;
    pub extern fn state_get_string(key_ptr: [*]const u8, key_len: i32, out_ptr: [*]u8, out_len: i32) i32;
    pub extern fn state_set_string(key_ptr: [*]const u8, key_len: i32, value_ptr: [*]const u8, value_len: i32) i32;
    pub extern fn state_delete(key_ptr: [*]const u8, key_len: i32) i32;
    pub extern fn job_index_builder_create(url_ptr: [*]const u8, url_len: i32, document_id_low: i64, document_id_high: i64, host_id_low: i64, host_id_high: i64) i32;
    pub extern fn job_index_builder_add_field(handle: i32, ptr: [*]const u8, len: i32) void;
    pub extern fn job_index_builder_add_markdown(handle: i32, ptr: [*]const u8, len: i32) void;
    pub extern fn job_index_builder_add_header(handle: i32, k_ptr: [*]const u8, k_len: i32, v_ptr: [*]const u8, v_len: i32) void;
    pub extern fn job_index_builder_add_metadata(handle: i32, k_ptr: [*]const u8, k_len: i32, v_ptr: [*]const u8, v_len: i32) void;
    pub extern fn job_index_builder_add_collection(handle: i32, ptr: [*]const u8) void;
    pub extern fn job_index_builder_add_source(handle: i32, ptr: [*]const u8) void;
    pub extern fn job_index_builder_build_post(handle: i32, content_type_ptr: [*]const u8, content_type_len: i32) i32;
    pub extern fn job_download_builder_create(url_ptr: [*]const u8, url_len: i32, document_id_low: i64, document_id_high: i64, host_id_low: i64, host_id_high: i64) i32;
    pub extern fn job_download_builder_add_content(handle: i32, ptr: [*]const u8, len: i32) void;
    pub extern fn job_download_builder_add_header(handle: i32, k_ptr: [*]const u8, k_len: i32, v_ptr: [*]const u8, v_len: i32) void;
    pub extern fn job_download_builder_add_metadata(handle: i32, k_ptr: [*]const u8, k_len: i32, v_ptr: [*]const u8, v_len: i32) void;
    pub extern fn job_download_builder_add_status_code(handle: i32, status_code: i32) void;
    pub extern fn job_download_builder_add_collection(handle: i32, ptr: [*]const u8) void;
    pub extern fn job_download_builder_add_source(handle: i32, ptr: [*]const u8) void;
    pub extern fn job_download_builder_build_post(handle: i32, content_type_ptr: [*]const u8, content_type_len: i32) i32;

    // KPI
    pub extern fn kpi_track_event(indicator: i32, ptr: [*]const u8, len: i32) void;
    pub extern fn kpi_execution_time_start(indicator: i32) i32;
    pub extern fn kpi_execution_time_stop(handle: i32) void;
};

pub const LogLevel = enum(i32) {
    Trace = 0,
    Debug = 1,
    Info = 2,
    Warn = 3,
    Error = 4,
    Critical = 5,
};

pub const Fingerprint = u128;

const FingerprintParts = struct {
    low: i64,
    high: i64,
};

pub fn log(level: LogLevel, message: []const u8) void {
    Host.trace_log(@intFromEnum(level), message.ptr, @intCast(message.len));
}

pub fn detectLanguage(text: []const u8) i32 {
    return Host.language_detect(text.ptr, @intCast(text.len));
}

pub fn computeFingerprint(text: []const u8) Fingerprint {
    var result: [16]u8 = undefined;
    Host.fingerprint_compute_string(text.ptr, @intCast(text.len), &result);
    return std.mem.readInt(u128, &result, .little);
}

pub fn computeFingerprintBytes(bytes: []const u8) Fingerprint {
    var result: [16]u8 = undefined;
    Host.fingerprint_compute_bytes(bytes.ptr, @intCast(bytes.len), &result);
    return std.mem.readInt(u128, &result, .little);
}

pub fn computeFingerprintUri(uri: []const u8) Fingerprint {
    var result: [16]u8 = undefined;
    Host.fingerprint_compute_uri(uri.ptr, @intCast(uri.len), &result);
    return std.mem.readInt(u128, &result, .little);
}

pub fn computeFingerprintHost(uri: []const u8) Fingerprint {
    var result: [16]u8 = undefined;
    Host.fingerprint_compute_host(uri.ptr, @intCast(uri.len), &result);
    return std.mem.readInt(u128, &result, .little);
}

pub const FieldType = enum(i32) {
    VerbatimString = 0,
    Text = 1,
    MainContent = 2,
    DateTime = 10,
    DateTimeOffset = 11,
    DateOnly = 12,
    Geo = 20,
    Wkt = 21,
    Binary = 30,
    NumberShort = 40,
    NumberInt = 41,
    NumberLong = 42,
    NumberSingle = 43,
    NumberDouble = 44,
    Embedding = 50,
};

pub const FieldStore = enum(i32) {
    Yes = 0,
    No = 1,
};

pub const FieldDatePrecision = enum(i32) {
    None = 0,
    Year = 1,
    Month = 2,
    Day = 3,
    Hour = 4,
    Minute = 5,
    Second = 6,
    Millisecond = 7,
};

pub const TextIndexOptions = enum(i32) {
    None = 0,
    DocsOnly = 1,
    DocsAndFreqs = 2,
    DocsAndFreqsAndPositions = 3,
    DocsAndFreqsAndPositionsAndOffsets = 4,
};

pub const RelationshipTypes = enum(i32) {
    None = 0,
    Alternate = 1,
    Author = 2,
    Next = 3,
    Tag = 4,
    Canonical = 5,
    Icon = 6,
    Prev = 7,
    License = 8,
};

pub const KeyPerformanceIndicators = enum(i32) {
    None = 0,
    PerformSearch = 1,
    SearchCompletionTime = 2,
    SearchLanguage = 3,
    AddRawDocument = 100,
    UpdateDocument = 101,
    DeleteDocument = 102,
    DeleteByQueryDocument = 103,
    PushDocument = 104,
    ExecutionTime = 200,
    LoadAssembly = 300,
};

pub const TextFieldConfiguration = struct {
    is_indexed: bool = true,
    is_tokenized: bool = true,
    is_stored: bool = true,
    term_vector_offsets: bool = false,
    term_vector_positions: bool = true,
    term_vectors: bool = false,
    term_vector_payloads: bool = false,
    index_options: TextIndexOptions = .DocsAndFreqsAndPositions,

    pub fn serialize(self: TextFieldConfiguration, writer: anytype) !void {
        try writer.writeByte(0x98); // Array 8
        try writer.writeByte(if (self.is_indexed) 0xc3 else 0xc2);
        try writer.writeByte(if (self.is_tokenized) 0xc3 else 0xc2);
        try writer.writeByte(if (self.is_stored) 0xc3 else 0xc2);
        try writer.writeByte(if (self.term_vector_offsets) 0xc3 else 0xc2);
        try writer.writeByte(if (self.term_vector_positions) 0xc3 else 0xc2);
        try writer.writeByte(if (self.term_vectors) 0xc3 else 0xc2);
        try writer.writeByte(if (self.term_vector_payloads) 0xc3 else 0xc2);
        try writeI32(writer, @intFromEnum(self.index_options));
    }
};

pub const GeoPoint = struct {
    longitude: f64,
    latitude: f64,
    altitude: ?f64 = null,

    pub fn serialize(self: GeoPoint, writer: anytype) !void {
        try writer.writeByte(0x93); // Array 3
        try writeF64(writer, self.longitude);
        try writeF64(writer, self.latitude);
        if (self.altitude) |alt| {
            try writeF64(writer, alt);
        } else {
            try writer.writeByte(0xc0);
        }
    }
};

pub const FieldValue = union(enum) {
    none: void,
    string: []const u8,
    int: i64,
    float: f64,
    geo: GeoPoint,
    binary: []const u8,
    vector: []const f32,

    pub fn serialize(self: FieldValue, writer: anytype) !void {
        switch (self) {
            .none => try writer.writeByte(0xc0),
            .string => |s| try writeString(writer, s),
            .int => |i| try writeI64(writer, i),
            .float => |f| try writeF64(writer, f),
            .geo => |g| try g.serialize(writer),
            .binary => |b| try writeBinary(writer, b),
            .vector => |v| {
                if (v.len < 16) {
                    try writer.writeByte(0x90 | @as(u8, @intCast(v.len)));
                } else if (v.len < 65536) {
                    try writer.writeByte(0xdc);
                    var lenBytes: [2]u8 = undefined;
                    std.mem.writeInt(u16, &lenBytes, @intCast(v.len), .big);
                    try writer.writeAll(&lenBytes);
                } else {
                    try writer.writeByte(0xdd);
                    var lenBytes: [4]u8 = undefined;
                    std.mem.writeInt(u32, &lenBytes, @intCast(v.len), .big);
                    try writer.writeAll(&lenBytes);
                }
                for (v) |f| try writeF32(writer, f);
            },
        }
    }
};

pub const Ulid = extern struct {
    bytes: [16]u8,

    pub fn deserialize(reader: anytype) !Ulid {
        var ulid: Ulid = undefined;
        const header = try reader.readByte();
        if (header != 0xc4) return error.InvalidUlidFormat;
        const len = try reader.readByte();
        if (len != 16) return error.InvalidUlidSize;
        ulid.bytes = try reader.readBytesNoEof(16);
        return ulid;
    }
};

pub const Subscription = struct {
    id: Ulid,

    pub fn deserialize(reader: anytype) !Subscription {
        const header = try reader.readByte();
        if (header != 0x91) return error.InvalidSubscriptionFormat;
        const id = try Ulid.deserialize(reader);
        return .{ .id = id };
    }
};

pub const Indexer = struct {
    pub const Builder = struct {
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) Builder {
            return .{ .allocator = allocator };
        }

        pub fn addField(self: Builder, name: []const u8, value: FieldValue, f_type: FieldType, store: FieldStore,
            date_precision: ?FieldDatePrecision, boost: ?f32, language_code: ?[]const u8, text_config: ?TextFieldConfiguration) !void {
            var output: std.Io.Writer.Allocating = .init(self.allocator);
            defer output.deinit();
            const writer = &output.writer;

            // FieldDto (Array 8)
            try writer.writeByte(0x98);
            try writeString(writer, name);
            try value.serialize(writer);
            try writeI32(writer, @intFromEnum(f_type));
            try writeI32(writer, @intFromEnum(store));
            if (date_precision) |dp| {
                try writeI32(writer, @intFromEnum(dp));
            } else {
                try writer.writeByte(0xc0);
            }
            if (boost) |b| {
                try writeF32(writer, b);
            } else {
                try writer.writeByte(0xc0);
            }
            if (language_code) |lc| {
                try writeString(writer, lc);
            } else {
                try writer.writeByte(0xc0);
            }
            if (text_config) |tc| {
                try tc.serialize(writer);
            } else {
                try writer.writeByte(0xc0);
            }

            const written = output.written();
            Host.builder_add_field(written.ptr, @intCast(written.len));
        }

        pub fn addLanguage(_: Builder, code: []const u8) void {
            Host.builder_add_language(code.ptr, @intCast(code.len));
        }

        pub fn addCreationDate(_: Builder, ticks: i64, offset_minutes: i32) void {
            Host.builder_add_creation_date(ticks, offset_minutes);
        }

        pub fn addModificationDate(_: Builder, ticks: i64, offset_minutes: i32) void {
            Host.builder_add_modification_date(ticks, offset_minutes);
        }

        pub fn addRelationship(_: Builder, url: []const u8, text: []const u8, title: ?[]const u8, rel_type: RelationshipTypes) void {
            const t_ptr = if (title) |t| t.ptr else "";
            const t_len = if (title) |t| @as(i32, @intCast(t.len)) else 0;
            Host.builder_add_relationship(url.ptr, @intCast(url.len), text.ptr, @intCast(text.len), t_ptr, t_len, @intFromEnum(rel_type));
        }

        pub fn addCollection(_: Builder, collectionId: Ulid) void {
            Host.builder_add_collection(&collectionId.bytes);
        }

        pub fn addSource(_: Builder, sourceId: Ulid) void {
            Host.builder_add_source(&sourceId.bytes);
        }

        pub fn addOriginalUrl(_: Builder, url: []const u8) void {
            Host.builder_add_original_url(url.ptr, @intCast(url.len));
        }

        pub fn addHeader(_: Builder, key: []const u8, val: []const u8) void {
            Host.builder_add_header(key.ptr, @intCast(key.len), val.ptr, @intCast(val.len));
        }

        pub fn addMarkdown(_: Builder, markdown: []const u8) void {
            Host.builder_add_markdown(markdown.ptr, @intCast(markdown.len));
        }

        pub fn build(_: Builder, contentType: []const u8) void {
            Host.builder_build(contentType.ptr, @intCast(contentType.len));
        }
    };
};

pub const DocumentRepository = struct {
    pub fn getLastModified(fingerprint: Fingerprint, collectionId: Ulid) i64 {
        const parts = fingerprintToHost(fingerprint);
        return Host.repo_get_last_modified(parts.low, parts.high, &collectionId.bytes);
    }

    pub fn findFetchMetadataJson(allocator: std.mem.Allocator, fingerprint: Fingerprint) !?[]u8 {
        const parts = fingerprintToHost(fingerprint);
        return readHostString(allocator, 64 * 1024, Host.repo_find_fetch_metadata_json, .{ parts.low, parts.high });
    }
};

pub const JobStateStore = struct {
    pub fn getString(allocator: std.mem.Allocator, key: []const u8) !?[]u8 {
        return readHostString(allocator, 4096, Host.state_get_string, .{ key.ptr, @as(i32, @intCast(key.len)) });
    }

    pub fn setString(key: []const u8, value: []const u8) bool {
        return Host.state_set_string(key.ptr, @intCast(key.len), value.ptr, @intCast(value.len)) == 1;
    }

    pub fn delete(key: []const u8) bool {
        return Host.state_delete(key.ptr, @intCast(key.len)) == 1;
    }
};

pub const JobIndexBuilder = struct {
    handle: i32,

    pub fn init(url: []const u8, document_id: Fingerprint, host_id: Fingerprint) JobIndexBuilder {
        const document_parts = fingerprintToHost(document_id);
        const host_parts = fingerprintToHost(host_id);
        return .{ .handle = Host.job_index_builder_create(url.ptr, @intCast(url.len), document_parts.low, document_parts.high, host_parts.low, host_parts.high) };
    }

    pub fn addField(self: JobIndexBuilder, allocator: std.mem.Allocator, name: []const u8, value: FieldValue, f_type: FieldType, store: FieldStore,
        date_precision: ?FieldDatePrecision, boost: ?f32, language_code: ?[]const u8, text_config: ?TextFieldConfiguration) !void {
        var output: std.Io.Writer.Allocating = .init(allocator);
        defer output.deinit();
        const writer = &output.writer;

        try writer.writeByte(0x98);
        try writeString(writer, name);
        try value.serialize(writer);
        try writeI32(writer, @intFromEnum(f_type));
        try writeI32(writer, @intFromEnum(store));
        if (date_precision) |dp| {
            try writeI32(writer, @intFromEnum(dp));
        } else {
            try writer.writeByte(0xc0);
        }
        if (boost) |b| {
            try writeF32(writer, b);
        } else {
            try writer.writeByte(0xc0);
        }
        if (language_code) |lc| {
            try writeString(writer, lc);
        } else {
            try writer.writeByte(0xc0);
        }
        if (text_config) |tc| {
            try tc.serialize(writer);
        } else {
            try writer.writeByte(0xc0);
        }

        const written = output.written();
        Host.job_index_builder_add_field(self.handle, written.ptr, @intCast(written.len));
    }

    pub fn addMarkdown(self: JobIndexBuilder, markdown: []const u8) void {
        Host.job_index_builder_add_markdown(self.handle, markdown.ptr, @intCast(markdown.len));
    }

    pub fn addHeader(self: JobIndexBuilder, key: []const u8, value: []const u8) void {
        Host.job_index_builder_add_header(self.handle, key.ptr, @intCast(key.len), value.ptr, @intCast(value.len));
    }

    pub fn addMetadata(self: JobIndexBuilder, key: []const u8, value: []const u8) void {
        Host.job_index_builder_add_metadata(self.handle, key.ptr, @intCast(key.len), value.ptr, @intCast(value.len));
    }

    pub fn addCollection(self: JobIndexBuilder, collectionId: Ulid) void {
        Host.job_index_builder_add_collection(self.handle, &collectionId.bytes);
    }

    pub fn addSource(self: JobIndexBuilder, sourceId: Ulid) void {
        Host.job_index_builder_add_source(self.handle, &sourceId.bytes);
    }

    pub fn buildPost(self: JobIndexBuilder, contentType: []const u8) bool {
        return Host.job_index_builder_build_post(self.handle, contentType.ptr, @intCast(contentType.len)) == 1;
    }
};

pub const JobDownloadBuilder = struct {
    handle: i32,

    pub fn init(url: []const u8, document_id: Fingerprint, host_id: Fingerprint) JobDownloadBuilder {
        const document_parts = fingerprintToHost(document_id);
        const host_parts = fingerprintToHost(host_id);
        return .{ .handle = Host.job_download_builder_create(url.ptr, @intCast(url.len), document_parts.low, document_parts.high, host_parts.low, host_parts.high) };
    }

    pub fn addContent(self: JobDownloadBuilder, content: []const u8) void {
        Host.job_download_builder_add_content(self.handle, content.ptr, @intCast(content.len));
    }

    pub fn addHeader(self: JobDownloadBuilder, key: []const u8, value: []const u8) void {
        Host.job_download_builder_add_header(self.handle, key.ptr, @intCast(key.len), value.ptr, @intCast(value.len));
    }

    pub fn addMetadata(self: JobDownloadBuilder, key: []const u8, value: []const u8) void {
        Host.job_download_builder_add_metadata(self.handle, key.ptr, @intCast(key.len), value.ptr, @intCast(value.len));
    }

    pub fn addStatusCode(self: JobDownloadBuilder, statusCode: ?i32) void {
        Host.job_download_builder_add_status_code(self.handle, statusCode orelse -1);
    }

    pub fn addCollection(self: JobDownloadBuilder, collectionId: Ulid) void {
        Host.job_download_builder_add_collection(self.handle, &collectionId.bytes);
    }

    pub fn addSource(self: JobDownloadBuilder, sourceId: Ulid) void {
        Host.job_download_builder_add_source(self.handle, &sourceId.bytes);
    }

    pub fn buildPost(self: JobDownloadBuilder, contentType: []const u8) bool {
        return Host.job_download_builder_build_post(self.handle, contentType.ptr, @intCast(contentType.len)) == 1;
    }
};

pub const JobResultPipeline = struct {
    pub fn postIndex(documentIndexBytes: []const u8) bool {
        return Host.pipeline_post_index(documentIndexBytes.ptr, @intCast(documentIndexBytes.len)) == 1;
    }

    pub fn postDownload(documentDownloadBytes: []const u8) bool {
        return Host.pipeline_post_download(documentDownloadBytes.ptr, @intCast(documentDownloadBytes.len)) == 1;
    }

    pub fn delete(fingerprint: Fingerprint) bool {
        var buf: [19]u8 = undefined;
        writeFingerprint(&buf, fingerprint);
        return Host.pipeline_delete(&buf, buf.len) == 1;
    }
};

pub const Job = struct {
    pub const Kpi = struct {
        pub fn trackEvent(allocator: std.mem.Allocator, indicator: KeyPerformanceIndicators, params: anytype) !void {
            var output: std.Io.Writer.Allocating = .init(allocator);
            defer output.deinit();
            const writer = &output.writer;

            // Serialize as Array of (Key, Value) pairs
            const fields = std.meta.fields(@TypeOf(params));
            try writeArrayHeader(writer, fields.len);
            inline for (fields) |f| {
                try writer.writeByte(0x92); // Array of 2 (Key, Value)
                try writeString(writer, f.name);
                const val = @field(params, f.name);
                try serializeAny(writer, val);
            }

            const written = output.written();
            Host.kpi_track_event(@intFromEnum(indicator), written.ptr, @intCast(written.len));
        }

        pub fn trackExecutionTime(indicator: KeyPerformanceIndicators) KpiTimer {
            return .{ .handle = Host.kpi_execution_time_start(@intFromEnum(indicator)) };
        }

        /// Executes a function and measures its performance using a KPI timer.
        /// The timer is automatically stopped when the function returns, ensuring no handle leaks.
        pub fn measure(indicator: KeyPerformanceIndicators, action: anytype, args: anytype) @TypeOf(@call(.auto, action, args)) {
            const timer = trackExecutionTime(indicator);
            defer timer.stop();
            return @call(.auto, action, args);
        }
    };

    pub const KpiTimer = struct {
        handle: i32,
        pub fn stop(self: KpiTimer) void {
            Host.kpi_execution_time_stop(self.handle);
        }
    };
};

fn serializeAny(writer: anytype, val: anytype) !void {
    const T = @TypeOf(val);
    if (T == []const u8 or T == []u8 or (@typeInfo(T) == .pointer and @typeInfo(@typeInfo(T).pointer.child) == .array and @typeInfo(@typeInfo(T).pointer.child).array.child == u8)) {
        try writeString(writer, val);
    } else if ((@typeInfo(T) == .int and @typeInfo(T).int.signedness == .unsigned) or (@typeInfo(T) == .comptime_int and val > std.math.maxInt(i64))) {
        try writer.writeByte(0xcf);
        var bytes: [8]u8 = undefined;
        std.mem.writeInt(u64, &bytes, std.math.cast(u64, val) orelse return error.KpiIntegerOutOfRange, .big);
        try writer.writeAll(&bytes);
    } else if (@typeInfo(T) == .int or @typeInfo(T) == .comptime_int) {
        try writeI64(writer, std.math.cast(i64, val) orelse return error.KpiIntegerOutOfRange);
    } else if (@typeInfo(T) == .float or @typeInfo(T) == .comptime_float) {
        try writeF64(writer, val);
    } else if (T == bool) {
        try writer.writeByte(if (val) 0xc3 else 0xc2);
    } else if (@typeInfo(T) == .null) {
        try writer.writeByte(0xc0);
    } else {
        @compileError("Unsupported KPI value type: " ++ @typeName(T));
    }
}

fn readHostString(allocator: std.mem.Allocator, initial_size: usize, comptime read: anytype, args: anytype) !?[]u8 {
    var buffer = try allocator.alloc(u8, initial_size);
    errdefer allocator.free(buffer);
    while (true) {
        const len = @call(.auto, read, args ++ .{ buffer.ptr, @as(i32, @intCast(buffer.len)) });
        switch (len) {
            -1 => {
                allocator.free(buffer);
                return null;
            },
            -2 => {
                const capacity = @min(buffer.len *| 2, std.math.maxInt(i32));
                if (capacity <= buffer.len) return error.HostStringTooLarge;
                buffer = try allocator.realloc(buffer, capacity);
            },
            else => {
                if (len < 0 or len > buffer.len) return error.InvalidHostStringLength;
                return try allocator.realloc(buffer, @intCast(len));
            },
        }
    }
}

fn writeArrayHeader(writer: anytype, len: usize) !void {
    if (len < 16) {
        try writer.writeByte(0x90 | @as(u8, @intCast(len)));
    } else if (len <= std.math.maxInt(u16)) {
        try writer.writeByte(0xdc);
        var bytes: [2]u8 = undefined;
        std.mem.writeInt(u16, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    } else {
        try writer.writeByte(0xdd);
        var bytes: [4]u8 = undefined;
        std.mem.writeInt(u32, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    }
}


fn fingerprintToHost(fingerprint: Fingerprint) FingerprintParts {
    const low: u64 = @truncate(fingerprint);
    const high: u64 = @truncate(fingerprint >> 64);
    return .{ .low = @bitCast(low), .high = @bitCast(high) };
}

fn writeFingerprint(buf: *[19]u8, fingerprint: Fingerprint) void {
    const upper: u64 = @truncate(fingerprint >> 64);
    const lower: u64 = @truncate(fingerprint);
    buf[0] = 0x92;
    buf[1] = 0xcf;
    std.mem.writeInt(u64, buf[2..10], upper, .big);
    buf[10] = 0xcf;
    std.mem.writeInt(u64, buf[11..19], lower, .big);
}

fn writeString(writer: anytype, s: []const u8) !void {
    const len = s.len;
    if (len < 32) {
        try writer.writeByte(0xa0 | @as(u8, @intCast(len)));
    } else if (len < 256) {
        try writer.writeByte(0xd9);
        try writer.writeByte(@as(u8, @intCast(len)));
    } else if (len <= std.math.maxInt(u16)) {
        try writer.writeByte(0xda);
        var bytes: [2]u8 = undefined;
        std.mem.writeInt(u16, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    } else {
        try writer.writeByte(0xdb);
        var bytes: [4]u8 = undefined;
        std.mem.writeInt(u32, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    }
    try writer.writeAll(s);
}

fn writeBinary(writer: anytype, b: []const u8) !void {
    const len = b.len;
    if (len < 256) {
        try writer.writeByte(0xc4);
        try writer.writeByte(@as(u8, @intCast(len)));
    } else if (len <= std.math.maxInt(u16)) {
        try writer.writeByte(0xc5);
        var bytes: [2]u8 = undefined;
        std.mem.writeInt(u16, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    } else {
        try writer.writeByte(0xc6);
        var bytes: [4]u8 = undefined;
        std.mem.writeInt(u32, &bytes, @intCast(len), .big);
        try writer.writeAll(&bytes);
    }
    try writer.writeAll(b);
}

fn writeI32(writer: anytype, val: i32) !void {
    if (val >= 0 and val < 128) {
        try writer.writeByte(@intCast(val));
    } else {
        try writer.writeByte(0xd2);
        var bytes: [4]u8 = undefined;
        std.mem.writeInt(i32, &bytes, val, .big);
        try writer.writeAll(&bytes);
    }
}

fn writeI64(writer: anytype, val: i64) !void {
    try writer.writeByte(0xd3);
    var bytes: [8]u8 = undefined;
    std.mem.writeInt(i64, &bytes, val, .big);
    try writer.writeAll(&bytes);
}

fn writeF32(writer: anytype, val: f32) !void {
    try writer.writeByte(0xca);
    var bytes: [4]u8 = undefined;
    std.mem.writeInt(u32, &bytes, @bitCast(val), .big);
    try writer.writeAll(&bytes);
}

fn writeF64(writer: anytype, val: f64) !void {
    try writer.writeByte(0xcb);
    var bytes: [8]u8 = undefined;
    std.mem.writeInt(u64, &bytes, @bitCast(val), .big);
    try writer.writeAll(&bytes);
}

test "LogLevel enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(LogLevel.Trace));
    try std.testing.expectEqual(@as(i32, 5), @intFromEnum(LogLevel.Critical));
}

test "FieldType enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(FieldType.VerbatimString));
    try std.testing.expectEqual(@as(i32, 1), @intFromEnum(FieldType.Text));
    try std.testing.expectEqual(@as(i32, 20), @intFromEnum(FieldType.Geo));
    try std.testing.expectEqual(@as(i32, 50), @intFromEnum(FieldType.Embedding));
}

test "FieldDatePrecision enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(FieldDatePrecision.None));
    try std.testing.expectEqual(@as(i32, 7), @intFromEnum(FieldDatePrecision.Millisecond));
}

test "FieldStore enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(FieldStore.Yes));
    try std.testing.expectEqual(@as(i32, 1), @intFromEnum(FieldStore.No));
}

test "RelationshipTypes enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(RelationshipTypes.None));
    try std.testing.expectEqual(@as(i32, 5), @intFromEnum(RelationshipTypes.Canonical));
}

test "KeyPerformanceIndicators enum values" {
    try std.testing.expectEqual(@as(i32, 0), @intFromEnum(KeyPerformanceIndicators.None));
    try std.testing.expectEqual(@as(i32, 100), @intFromEnum(KeyPerformanceIndicators.AddRawDocument));
    try std.testing.expectEqual(@as(i32, 300), @intFromEnum(KeyPerformanceIndicators.LoadAssembly));
}

test "GeoPoint serialize" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const gp = GeoPoint{ .longitude = 1.0, .latitude = 2.0, .altitude = 3.0 };
    try gp.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0x93), buf[0]);
}

test "GeoPoint serialize null altitude" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const gp = GeoPoint{ .longitude = 1.0, .latitude = 2.0, .altitude = null };
    try gp.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0x93), buf[0]);
    const written = fbs.getWritten();
    try std.testing.expectEqual(@as(u8, 0xc0), written[written.len - 1]);
}

test "TextFieldConfiguration serialize defaults" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const cfg = TextFieldConfiguration{};
    try cfg.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0x98), buf[0]);
}

test "TextFieldConfiguration serialize custom" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const cfg = TextFieldConfiguration{
        .is_indexed = false,
        .is_tokenized = true,
        .is_stored = false,
        .term_vector_offsets = true,
        .term_vector_positions = false,
        .term_vectors = true,
        .term_vector_payloads = true,
        .index_options = .DocsAndFreqsAndPositionsAndOffsets,
    };
    try cfg.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0x98), buf[0]);
}

test "FieldValue none" {
    var buf: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .none = {} };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xc0), buf[0]);
}

test "FieldValue string" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .string = "hello" };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xa5), buf[0]);
}

test "FieldValue int" {
    var buf: [16]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .int = 42 };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xd3), buf[0]);
}

test "FieldValue float" {
    var buf: [16]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .float = 3.14 };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xcb), buf[0]);
}

test "FieldValue binary" {
    var buf: [32]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .binary = &.{ 1, 2, 3 } };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xc4), buf[0]);
    try std.testing.expectEqual(@as(u8, 3), buf[1]);
}

test "FieldValue vector small (< 16 elements)" {
    var buf: [64]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const vec: [3]f32 = .{ 1.0, 2.0, 3.0 };
    const v = FieldValue{ .vector = &vec };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0x93), buf[0]);
}

test "FieldValue vector medium (16-65535 elements)" {
    var allocator = std.testing.allocator;
    const vec = try allocator.alloc(f32, 20);
    defer allocator.free(vec);
    @memset(vec, 1.5);

    var buf: [256]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .vector = vec };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xdc), buf[0]);
    try std.testing.expectEqual(@as(u8, 0), buf[1]);
    try std.testing.expectEqual(@as(u8, 20), buf[2]);
}

test "FieldValue vector large (65536+ elements)" {
    var allocator = std.testing.allocator;
    const vec = try allocator.alloc(f32, 70000);
    defer allocator.free(vec);
    @memset(vec, 0.5);

    var buf: [400000]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const v = FieldValue{ .vector = vec };
    try v.serialize(fbs.writer());
    try std.testing.expectEqual(@as(u8, 0xdd), buf[0]);
}

test "Ulid deserialize" {
    var msgpack_buf: [18]u8 = undefined;
    msgpack_buf[0] = 0xc4;
    msgpack_buf[1] = 16;
    const data: [16]u8 = .{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };
    @memcpy(msgpack_buf[2..18], &data);

    var fbs = std.io.fixedBufferStream(&msgpack_buf);
    const ulid = try Ulid.deserialize(fbs.reader());
    try std.testing.expectEqualSlices(u8, &data, &ulid.bytes);
}

test "Subscription deserialize" {
    var msgpack_buf: [20]u8 = undefined;
    msgpack_buf[0] = 0x91;
    msgpack_buf[1] = 0xc4;
    msgpack_buf[2] = 16;
    const data: [16]u8 = .{ 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42 };
    @memcpy(msgpack_buf[3..19], &data);

    var fbs = std.io.fixedBufferStream(&msgpack_buf);
    const sub = try Subscription.deserialize(fbs.reader());
    try std.testing.expectEqualSlices(u8, &data, &sub.id.bytes);
}

test "writeString short (< 32 bytes)" {
    var buf: [64]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeString(fbs.writer(), "hello");
    try std.testing.expectEqual(@as(u8, 0xa5), buf[0]);
    try std.testing.expectEqualStrings("hello", buf[1..6]);
}

test "writeString medium (32-255 bytes)" {
    var buf: [300]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const s = "abcdefghijklmnopqrstuvwxyz012345";
    try writeString(fbs.writer(), s);
    try std.testing.expectEqual(@as(u8, 0xd9), buf[0]);
    try std.testing.expectEqual(@as(u8, 32), buf[1]);
}

test "writeI32 positive fixnum" {
    var buf: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeI32(fbs.writer(), 42);
    try std.testing.expectEqual(@as(u8, 42), buf[0]);
}

test "writeI32 negative" {
    var buf: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeI32(fbs.writer(), -1);
    try std.testing.expectEqual(@as(u8, 0xd2), buf[0]);
}

test "writeI64" {
    var buf: [16]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeI64(fbs.writer(), 9223372036854775807);
    try std.testing.expectEqual(@as(u8, 0xd3), buf[0]);
}

test "writeFingerprint" {
    var buf: [19]u8 = undefined;
    writeFingerprint(&buf, 0x01020304050607081112131415161718);
    try std.testing.expectEqualSlices(u8, &.{
        0x92, 0xcf, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0xcf, 0x11, 0x12,
        0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    }, &buf);
}

test "writeF32" {
    var buf: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeF32(fbs.writer(), 1.5);
    try std.testing.expectEqual(@as(u8, 0xca), buf[0]);
}

test "writeF64" {
    var buf: [16]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    try writeF64(fbs.writer(), 3.14159265358979);
    try std.testing.expectEqual(@as(u8, 0xcb), buf[0]);
}
