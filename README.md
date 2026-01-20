# Project 1 README

## Project Status

This the current status of the project: finished, with some C++20 Ranges magic ;)

## Known Issues

The project fails to function properly in: no circumstances, as of the test shows. 100% coverage.

## Code References

* [Makefile Tutorial by Example](https://makefiletutorial.com/)
* [C++ Strings Library](https://en.cppreference.com/w/cpp/string/basic_string.html)
* [C++ Ranges Library](https://en.cppreference.com/w/cpp/ranges.html)

## Generative AI Use

### Prompt 1

I have a vector of strings and I want to get a vectors of string_views without copying. How can I do that in C++ 23

### Answer 1 (Gemini 2.5 Pro)

In C++23, the most efficient and idiomatic way to do this is by using **`std::ranges::views::transform`** combined with the new **`std::ranges::to`** container converter.

This approach allows you to create the new vector in a single, readable expression without manually writing loops or calling `push_back`.

### The C++23 Way

```cpp
#include <vector>
#include <string>
#include <string_view>
#include <ranges>

int main() {
    std::vector<std::string> words = {"Apple", "Banana", "Cherry"};

    // 1. Transform the strings into views
    // 2. Convert the resulting range directly into a vector
    auto views = words | std::views::transform([](const std::string& s) {
        return std::string_view(s);
    }) | std::ranges::to<std::vector<std::string_view>>();

    return 0;
}

```

---

### Why this works

* **`std::views::transform`**: This creates a "lazy" view. It doesn't actually create any new strings; it just provides a way to look at the existing `std::string` objects as `std::string_view`.
* **`std::ranges::to<std::vector<...>>`**: This is the "missing link" introduced in C++23. It takes the lazy range produced by the transform and "materializes" it into a new container of your choice.
* **No Copying**: Because `std::string_view` is just a pointer and a length, you are only copying the "metadata" (about 16 bytes), not the actual heap-allocated string data.

### Performance and Safety Note

| Aspect | Behavior |
| --- | --- |
| **Allocation** | Only one allocation occurs for the `std::vector` itself (to hold the pointers/sizes). |
| **Data Copying** | Zero. The actual characters stay inside the original `std::vector<std::string>`. |
| **Lifetime Risk** | **High.** The `string_view`s are only valid as long as the original `words` vector exists and is not modified (e.g., adding elements might cause a realloc, dangling your views). |

### Alternative: The "Constructor" Way

If you prefer not to use ranges, you can still use the constructor approach, which is also very efficient:

```cpp
std::vector<std::string_view> views(words.begin(), words.end());

```

*Note: This works because `std::string` is implicitly convertible to `std::string_view`. The compiler handles the transformation for you during the iteration.*

---

**Would you like to see how to use `std::span` if you need to view a sub-section of the vector itself instead of just the strings?**
