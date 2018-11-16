package com.example.koiketomoya.dijkstra;

import android.graphics.PointF;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.PriorityQueue;
import java.util.Scanner;


public class Solver {
    private ArrayList<PointF> points; /* 与えられた点の集合 */
    private PointF goal;              /* ゴールの点 */

    public static final double OneHop = 1000.00001;

    void setupBoard(ArrayList<PointF> sentPoints) {
        points = sentPoints;
        goal = points.get(sentPoints.size()-1);
        System.out.println("Points: " + points);
        System.out.println("Goal: " + goal);
    }

    public double calcDistance(PointF a, PointF b) {
    	return Math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    }

    public double solve() {
        PriorityQueue<SearchNode> q = new PriorityQueue<>(new MyPointComp0()); /* 優先度キュー */
        HashMap<PointF,Double> visited = new HashMap<>();  /* 探索済みの点の管理 */
        PointF start = points.get(0);
        SearchNode rootNode = new SearchNode(0.0,start);
        System.out.println("search from " + rootNode);

        // TODO
        // 初期化
        for (PointF point : points) { visited.put(point, 1000000.0); }
        q.add(rootNode);
        visited.put(start, 0.0);
        SearchNode node = rootNode;

        // 探索開始
        while (!q.isEmpty()) {
        	node = q.poll();

        	// nodeのpriorityがvisited[node.point]より小さければ、continue. そうでなけれ更新
        	if (node.getPriority() > visited.get(node.point)) { continue; }
        	visited.put(node.point, node.getPriority());

        	// ゴールならばpriorityをreturn
        	if (node.point.equals(goal)) { return node.priority; }

        	// hereから各点までの距離を計算し、10以下ならばqueueに追加
            for (PointF point : points) {
            	// 自分の点と同じときはスキップ
            	if (node.point.equals(point)) { continue; }

            	// 距離計算
            	double distance = calcDistance(node.point, point);
//            	 if (distance == 0) { continue; }

            	if (distance <= OneHop) {
            		SearchNode newNode = new SearchNode(node.priority+distance, point);
            		// visitedの更新
            		if (node.getPriority() < visited.get(node.point)) {
            			visited.put(node.point, node.getPriority());
            		}
            		q.add(newNode);
            	}
            }
            // queueをソート

        }

        return 0.0;
    }

    public static void main(String[] args) throws IOException {
        int a = 1;
    }
}



