package com.example.koiketomoya.dijkstra;

import android.graphics.PointF;

public class SearchNode {
    double priority;
    PointF point;

    public SearchNode(double priority, PointF point) {
        this.priority = priority;
        this.point = point;
    }

    double getPriority() {
        return priority;
    }
}