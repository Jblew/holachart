<template>
  <div ref="dst"></div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import * as d3 from "d3";

@Component
export default class Graph extends Vue {
  @Prop() private data!: any;

  mounted(): void {
    this._buildGraph();
  }

  _buildGraph(): void {
    console.log("Building holachart graph circlepack for:", this.data);
    const svg = this._buildGraphSVG();
    (this.$refs.dst as any).appendChild(svg.node());
  }

  _buildGraphSVG(): any {
    var svg = d3
        .create("svg")
        .attr("width", 960)
        .attr("height", 960),
      margin = 20,
      diameter = +svg.attr("width"),
      g = svg
        .append("g")
        .attr(
          "transform",
          "translate(" + diameter / 2 + "," + diameter / 2 + ")"
        );

    var color = d3
      .scaleLinear()
      .domain([-1, 5])
      .range(["hsl(152,80%,80%)", "hsl(228,30%,40%)"] as any)
      .interpolate(d3.interpolateHcl as any);

    var pack = d3
      .pack()
      .size([diameter - margin, diameter - margin])
      .padding(2);

    let root = this.data;
    root = d3
      .hierarchy(root)
      .sum(function(d) {
        return d.size;
      })
      .sort(function(a: any, b: any) {
        return b.value - a.value;
      });

    var focus = root,
      nodes = pack(root).descendants(),
      view: any;

    var circle = g
      .selectAll("circle")
      .data(nodes)
      .enter()
      .append("circle")
      .attr("class", function(d) {
        return d.parent
          ? d.children
            ? "node"
            : "node node--leaf"
          : "node node--root";
      })
      .style("fill", function(d) {
        return d.children ? color(d.depth) : null;
      })
      .on("click", function(d) {
        console.log("Click");
        if (focus !== d) zoom(d);
      });

    var text = g
      .selectAll("text")
      .data(nodes)
      .enter()
      .append("text")
      .attr("class", "label")
      .style("fill-opacity", function(d) {
        return d.parent === root ? 1 : 0;
      })
      .style("display", function(d) {
        return d.parent === root ? "inline" : "none";
      })
      .text(function(d) {
        return (d.data as any).name;
      });

    var node = g.selectAll("circle,text");

    svg.style("background", color(-1)).on("click", function() {
      zoom(root);
    });

    zoomTo([root.x, root.y, root.r * 2 + margin]);

    function zoom(d: any) {
      console.log("Zoom", d);
      var focus0 = focus;
      focus = d;

      var transition = d3
        .transition()
        .duration(750)
        .tween("zoom", function(d: any) {
          var i = d3.interpolateZoom(view, [
            focus.x,
            focus.y,
            focus.r * 2 + margin,
          ]);
          console.log("Zoom tween", view);
          return function(t) {
            zoomTo(i(t));
          };
        });

      transition
        .selectAll("text")
        .filter(function(this: any, d: any) {
          return d.parent === focus || this.style.display === "inline";
        })
        .style("fill-opacity", function(this: any, d: any) {
          return d.parent === focus ? 1 : 0;
        })
        .on("start", function(this: any, d: any) {
          if (d.parent === focus) this.style.display = "inline";
        })
        .on("end", function(this: any, d: any) {
          if (d.parent !== focus) this.style.display = "none";
        });
    }

    function zoomTo(v: any) {
      var k = diameter / v[2];
      view = v;
      node.attr("transform", function(d: any) {
        return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")";
      });
      circle.attr("r", function(d) {
        return d.r * k;
      });
    }
    return svg;
  }
}
</script>
<style>
.node {
  cursor: pointer;
}

.node:hover {
  stroke: #000;
  stroke-width: 1.5px;
}

.node--leaf {
  fill: white;
}

.label {
  font: 11px "Helvetica Neue", Helvetica, Arial, sans-serif;
  text-anchor: middle;
  text-shadow: 0 1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff, 0 -1px 0 #fff;
}

.label,
.node--root,
.node--leaf {
  pointer-events: none;
}
</style>
