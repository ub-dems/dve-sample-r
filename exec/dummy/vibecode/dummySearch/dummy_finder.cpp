// #:: AI Generated at 2025-10-31T14:32:45 -- Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)
// #:: @Seealso: notes/howtos/Rcpp-HOWTO-Q7-all.md
// #:: @Seealso: dummy-rcpp-finder.r
//
// Copyright (C) 2025 University of Milano-Bicocca
// Author: datalab <datalab@unimib.it>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

//#include <Rcpp.h>
#include <RcppArmadillo.h>
#include <RcppParallel.h>
#include <queue>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <cmath>
#include <limits>
#include <algorithm>
#include <mutex>

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppParallel)]]
// [[Rcpp::plugins(cpp17)]]

using namespace Rcpp;
using namespace RcppParallel;

// =======================================
// Common type definitions
// =======================================

using NodeId = int;
using Cost = double;
constexpr Cost INF = std::numeric_limits<Cost>::infinity();

// Node state for A* search
struct NodeState {
  NodeId id;
  Cost g_score;  // Cost from start
  Cost f_score;  // g_score + heuristic
  
  bool operator>(const NodeState& other) const {
    return f_score > other.f_score;
  }
};

// =======================================
// Anonymous namespace for utility functions
// =======================================

namespace {

// Reconstruct path from parent map
std::vector<int> reconstruct_path(
    const std::unordered_map<NodeId, NodeId>& came_from,
    NodeId current) {
  std::vector<int> path;
  path.push_back(current);
  
  while (came_from.find(current) != came_from.end()) {
    current = came_from.at(current);
    path.push_back(current);
  }
  
  std::reverse(path.begin(), path.end());
  return path;
}

// Get neighbors of a node from adjacency matrix
std::vector<NodeId> get_neighbors(const arma::mat& adj, NodeId node) {
  std::vector<NodeId> neighbors;
  const arma::rowvec row = adj.row(node);
  
  for (size_t i = 0; i < row.n_elem; ++i) {
    if (row(i) > 0 && row(i) < INF) {
      neighbors.push_back(static_cast<NodeId>(i));
    }
  }
  
  return neighbors;
}

} // namespace

// =======================================
// Common algorithm functions
// =======================================

// Compute Euclidean distance heuristic
double euclidean_heuristic(const arma::mat& positions, NodeId a, NodeId b) {
  double dx = positions(a, 0) - positions(b, 0);
  double dy = positions(a, 1) - positions(b, 1);
  return std::sqrt(dx * dx + dy * dy);
}

// =======================================
// Sequential algorithm functions
// =======================================

// Sequential A* pathfinding implementation
// Returns vector of node IDs from start to goal, or empty vector if no path
std::vector<int> dmy_astar_seq_finder_impl(
    const arma::mat& adjacency_matrix,
    const arma::mat& positions,
    int start,
    int goal) {
  
  const int n = adjacency_matrix.n_rows;
  
  // Handle edge cases
  if (start < 0 || start >= n || goal < 0 || goal >= n) {
    return std::vector<int>();
  }
  if (start == goal) {
    return std::vector<int>();
  }
  
  // Priority queue for open set (min-heap by f_score)
  std::priority_queue<NodeState, std::vector<NodeState>, 
                      std::greater<NodeState>> open_set;
  
  // Track visited nodes
  std::unordered_set<NodeId> closed_set;
  
  // Cost from start to each node
  std::unordered_map<NodeId, Cost> g_score;
  
  // Parent pointers for path reconstruction
  std::unordered_map<NodeId, NodeId> came_from;
  
  // Initialize start node
  g_score[start] = 0.0;
  Cost h_start = euclidean_heuristic(positions, start, goal);
  open_set.push({start, 0.0, h_start});
  
  while (!open_set.empty()) {
    NodeState current = open_set.top();
    open_set.pop();
    
    // Skip if already processed
    if (closed_set.count(current.id)) continue;
    
    // Goal reached
    if (current.id == goal) {
      return reconstruct_path(came_from, goal);
    }
    
    closed_set.insert(current.id);
    
    // Explore neighbors
    std::vector<NodeId> neighbors = get_neighbors(adjacency_matrix, current.id);
    
    for (NodeId neighbor : neighbors) {
      if (closed_set.count(neighbor)) continue;
      
      Cost edge_cost = adjacency_matrix(current.id, neighbor);
      Cost tentative_g = g_score[current.id] + edge_cost;
      
      // Check if this path is better
      if (g_score.find(neighbor) == g_score.end() || 
          tentative_g < g_score[neighbor]) {
        came_from[neighbor] = current.id;
        g_score[neighbor] = tentative_g;
        Cost h = euclidean_heuristic(positions, neighbor, goal);
        Cost f = tentative_g + h;
        open_set.push({neighbor, tentative_g, f});
      }
    }
  }
  
  // No path found
  return std::vector<int>();
}

//' Sequential A* Pathfinding
//'
//' Finds the shortest path between two nodes using A* algorithm.
//' Uses Euclidean distance as heuristic for admissible search.
//'
//' @param adjacency_matrix Square numeric matrix of edge weights (symmetric)
//' @param positions Two-column matrix of (x,y) coordinates for each node
//' @param start Integer index of start node (0-based)
//' @param goal Integer index of goal node (0-based)
//' @return Integer vector of node indices in path, or empty vector if no path
//'
//' @details
//' The algorithm guarantees finding the optimal path when the heuristic
//' is admissible (never overestimates). Edge weights must be non-negative.
//' The adjacency matrix should be symmetric for undirected graphs.
//'
//' @examples
//' \dontrun{
//' # Create simple 4-node graph
//' adj <- matrix(c(0, 1, 0, 0,
//'                 1, 0, 1, 0,
//'                 0, 1, 0, 1,
//'                 0, 0, 1, 0), 4, 4)
//' pos <- matrix(c(0, 0, 1, 0, 2, 0, 3, 0), 4, 2, byrow = TRUE)
//' path <- dmy_astar_seq_finder(adj, pos, 0L, 3L)
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::IntegerVector dmy_astar_seq_finder(
    Rcpp::NumericMatrix adjacency_matrix,
    Rcpp::NumericMatrix positions,
    int start,
    int goal) {
  
  // Convert to Armadillo matrices
  arma::mat adj = as<arma::mat>(adjacency_matrix);
  arma::mat pos = as<arma::mat>(positions);
  
  // Call implementation
  std::vector<int> path = dmy_astar_seq_finder_impl(adj, pos, start, goal);
  
  // Convert to R integer vector
  return wrap(path);
}

// =======================================
// Parallel algorithm functions
// =======================================

// Worker for parallel neighbor exploration
struct NeighborExplorer : public Worker {
  const arma::mat& adjacency;
  const arma::mat& positions;
  const std::vector<NodeId>& neighbors;
  const NodeId current_id;
  const Cost current_g;
  const NodeId goal;
  const std::unordered_map<NodeId, Cost>& g_score;
  
  // Thread-safe output structures
  std::mutex& result_mutex;
  std::vector<std::tuple<NodeId, NodeId, Cost, Cost>>& updates;
  
  NeighborExplorer(
      const arma::mat& adj,
      const arma::mat& pos,
      const std::vector<NodeId>& nbrs,
      NodeId curr_id,
      Cost curr_g,
      NodeId gl,
      const std::unordered_map<NodeId, Cost>& g_sc,
      std::mutex& mtx,
      std::vector<std::tuple<NodeId, NodeId, Cost, Cost>>& upd)
    : adjacency(adj), positions(pos), neighbors(nbrs),
      current_id(curr_id), current_g(curr_g), goal(gl),
      g_score(g_sc), result_mutex(mtx), updates(upd) {}
  
  void operator()(std::size_t begin, std::size_t end) {
    std::vector<std::tuple<NodeId, NodeId, Cost, Cost>> local_updates;
    
    for (std::size_t i = begin; i < end; ++i) {
      NodeId neighbor = neighbors[i];
      Cost edge_cost = adjacency(current_id, neighbor);
      Cost tentative_g = current_g + edge_cost;
      
      // Check if improvement (thread-local check, verified later)
      bool is_improvement = false;
      if (g_score.find(neighbor) == g_score.end()) {
        is_improvement = true;
      } else if (tentative_g < g_score.at(neighbor)) {
        is_improvement = true;
      }
      
      if (is_improvement) {
        Cost h = euclidean_heuristic(positions, neighbor, goal);
        Cost f = tentative_g + h;
        local_updates.push_back(
            std::make_tuple(neighbor, current_id, tentative_g, f));
      }
    }
    
    // Critical section: merge local updates
    if (!local_updates.empty()) {
      std::lock_guard<std::mutex> lock(result_mutex);
      updates.insert(updates.end(), 
                     local_updates.begin(), local_updates.end());
    }
  }
};

// Parallel A* pathfinding implementation
// Note: A* is inherently sequential in its core logic (node expansion order
// matters), but we parallelize the neighbor exploration step which can be
// compute-intensive for dense graphs or expensive heuristics.
std::vector<int> dmy_astar_par_finder_impl(
    const arma::mat& adjacency_matrix,
    const arma::mat& positions,
    int start,
    int goal) {
  
  const int n = adjacency_matrix.n_rows;
  
  // Handle edge cases
  if (start < 0 || start >= n || goal < 0 || goal >= n) {
    return std::vector<int>();
  }
  if (start == goal) {
    return std::vector<int>();
  }
  
  // Priority queue for open set
  std::priority_queue<NodeState, std::vector<NodeState>,
                      std::greater<NodeState>> open_set;
  
  std::unordered_set<NodeId> closed_set;
  std::unordered_map<NodeId, Cost> g_score;
  std::unordered_map<NodeId, NodeId> came_from;
  
  // Mutex for thread-safe operations
  std::mutex state_mutex;
  
  // Initialize
  g_score[start] = 0.0;
  Cost h_start = euclidean_heuristic(positions, start, goal);
  open_set.push({start, 0.0, h_start});
  
  while (!open_set.empty()) {
    NodeState current = open_set.top();
    open_set.pop();
    
    if (closed_set.count(current.id)) continue;
    
    if (current.id == goal) {
      return reconstruct_path(came_from, goal);
    }
    
    closed_set.insert(current.id);
    
    // Get neighbors
    std::vector<NodeId> neighbors = get_neighbors(adjacency_matrix, current.id);
    
    if (neighbors.empty()) continue;
    
    // Parallel neighbor exploration
    // CONCURRENCY NOTE: We use a mutex to protect the updates vector
    // Each thread explores a subset of neighbors independently
    std::vector<std::tuple<NodeId, NodeId, Cost, Cost>> updates;
    
    // Only parallelize if enough neighbors to benefit from parallelism
    if (neighbors.size() > 4) {
      NeighborExplorer explorer(
          adjacency_matrix, positions, neighbors,
          current.id, current.g_score, goal, g_score,
          state_mutex, updates);
      
      parallelFor(0, neighbors.size(), explorer);
    } else {
      // Sequential for small neighbor sets
      for (NodeId neighbor : neighbors) {
        if (closed_set.count(neighbor)) continue;
        
        Cost edge_cost = adjacency_matrix(current.id, neighbor);
        Cost tentative_g = g_score[current.id] + edge_cost;
        
        if (g_score.find(neighbor) == g_score.end() ||
            tentative_g < g_score[neighbor]) {
          Cost h = euclidean_heuristic(positions, neighbor, goal);
          Cost f = tentative_g + h;
          updates.push_back(
              std::make_tuple(neighbor, current.id, tentative_g, f));
        }
      }
    }
    
    // Apply updates from parallel exploration
    // CONCURRENCY NOTE: This section is sequential to maintain consistency
    for (const auto& upd : updates) {
      NodeId neighbor = std::get<0>(upd);
      NodeId parent = std::get<1>(upd);
      Cost tentative_g = std::get<2>(upd);
      Cost f = std::get<3>(upd);
      
      if (closed_set.count(neighbor)) continue;
      
      // Double-check improvement (another thread may have updated)
      if (g_score.find(neighbor) == g_score.end() ||
          tentative_g < g_score[neighbor]) {
        came_from[neighbor] = parent;
        g_score[neighbor] = tentative_g;
        open_set.push({neighbor, tentative_g, f});
      }
    }
  }
  
  return std::vector<int>();
}

//' Parallel A* Pathfinding
//'
//' Finds the shortest path using parallel neighbor exploration.
//' Parallelizes the evaluation of neighboring nodes using RcppParallel.
//'
//' @param adjacency_matrix Square numeric matrix of edge weights (symmetric)
//' @param positions Two-column matrix of (x,y) coordinates for each node
//' @param start Integer index of start node (0-based)
//' @param goal Integer index of goal node (0-based)
//' @return Integer vector of node indices in path, or empty vector if no path
//'
//' @details
//' The parallel implementation uses RcppParallel to explore neighbors
//' concurrently. Best performance is achieved with graphs having high
//' branching factors and many nodes. For small graphs, sequential version
//' may be faster due to parallelization overhead.
//'
//' @examples
//' \dontrun{
//' # Create simple 4-node graph
//' adj <- matrix(c(0, 1, 0, 0,
//'                 1, 0, 1, 0,
//'                 0, 1, 0, 1,
//'                 0, 0, 1, 0), 4, 4)
//' pos <- matrix(c(0, 0, 1, 0, 2, 0, 3, 0), 4, 2, byrow = TRUE)
//' path <- dmy_astar_par_finder(adj, pos, 0L, 3L)
//' }
//'
//' @export
// [[Rcpp::export]]
Rcpp::IntegerVector dmy_astar_par_finder(
    Rcpp::NumericMatrix adjacency_matrix,
    Rcpp::NumericMatrix positions,
    int start,
    int goal) {
  
  // Convert to Armadillo matrices
  arma::mat adj = as<arma::mat>(adjacency_matrix);
  arma::mat pos = as<arma::mat>(positions);
  
  // Call implementation
  std::vector<int> path = dmy_astar_par_finder_impl(adj, pos, start, goal);
  
  // Convert to R integer vector
  return wrap(path);
}
