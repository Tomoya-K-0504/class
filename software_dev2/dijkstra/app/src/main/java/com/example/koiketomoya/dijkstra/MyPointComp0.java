package com.example.koiketomoya.dijkstra;

import java.util.Comparator;

public class MyPointComp0 implements Comparator<SearchNode> {

	@Override
    public int compare(SearchNode node1, SearchNode node2) {
        return Double.compare(node1.priority, node2.priority);
    }
}
