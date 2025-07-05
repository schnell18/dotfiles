// JShell startup script with common imports and utilities

// Common imports for convenience
import java.util.*;
import java.util.stream.*;
import java.util.function.*;
import java.io.*;
import java.nio.file.*;
import java.time.*;
import java.time.format.*;
import java.math.*;
import java.text.*;

// Utility functions
void print(Object obj) {
    System.out.println(obj);
}

void printf(String format, Object... args) {
    System.out.printf(format, args);
}

// Helper for creating lists
<T> List<T> listOf(T... elements) {
    return Arrays.asList(elements);
}

// Helper for reading files
String readFile(String path) throws IOException {
    return Files.readString(Path.of(path));
}

// Helper for writing files
void writeFile(String path, String content) throws IOException {
    Files.writeString(Path.of(path), content);
}

// Current timestamp
String now() {
    return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
}

// Pretty print JSON-like output
void pp(Object obj) {
    if (obj instanceof Map) {
        ((Map<?, ?>) obj).forEach((k, v) -> System.out.println(k + " = " + v));
    } else if (obj instanceof Collection) {
        ((Collection<?>) obj).forEach(System.out::println);
    } else {
        System.out.println(obj);
    }
}

System.out.println("JShell startup script loaded - common imports and utilities available");