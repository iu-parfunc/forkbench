
/* 
 *
 * To compile:
 *   g++ -std=c++11 -pthread polling-vs-interrupts.cpp
 */

#include <iostream>
#include <chrono>
#include <thread>
#include <vector>

using cycles_type = uint64_t;

static constexpr
size_t nb_bins = 100;

static constexpr
size_t bin_sz = (1<<10);

static constexpr
int duration_sec = 2;

size_t histogram[nb_bins];

bool* global_flag;

static inline
cycles_type rdtsc() {
  unsigned int hi, lo;
  __asm__ __volatile__("rdtsc" : "=a"(lo), "=d"(hi));
  return  ((cycles_type) lo) | (((cycles_type) hi) << 32);
}

int main() {
  bool flag = false;
  std::vector<cycles_type> large_diffs;
  auto record_diff = [&] (cycles_type diff) {
    auto bin = diff / bin_sz;
    if (bin < nb_bins) {
      histogram[bin]++;
    } else {
      large_diffs.push_back(diff);
    }
  };
  auto t = std::thread([&] {
    global_flag = &flag;
    int i = 0;
    cycles_type a[2];
    while (1) {
      a[i] = rdtsc();
      record_diff(a[i] - a[!i]);
      i = !i;
      if (*global_flag) {
        return;
      }
    }
  });
  std::this_thread::sleep_for(std::chrono::seconds(duration_sec));
  flag = true;
  t.join();
  std::cout << "[ ";
  for (size_t i = 0; i < nb_bins; i++) {
    std::cout << histogram[i] << " ";
  }
  std::cout << "]" << std::endl;
  std::cout << "[ ";
  for (auto const& v: large_diffs) {
    std::cout << v << " ";
  }
  std::cout << "]" << std::endl;
  return 0;
}
