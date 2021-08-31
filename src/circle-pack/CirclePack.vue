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
    const w = 500;
    const h = 500;

    const svg = d3
      .create("svg")
      .attr("width", w)
      .attr("height", h);

    const sortedGDP = this.data.sort((a: any, b: any) =>
      a.value > b.value ? 1 : -1
    );
    const color = d3.scaleOrdinal(d3.schemeDark2);

    const max_gdp = d3.max(sortedGDP, (o: any) => o.value);

    const angleScale = d3
      .scaleLinear()
      .domain([0, max_gdp as any])
      .range([0, 1.5 * Math.PI]);

    const arc = d3
      .arc()
      .innerRadius((d: any, i: any) => (i + 1) * 25)
      .outerRadius((d: any, i: any) => (i + 2) * 25)
      .startAngle(angleScale(0))
      .endAngle((d: any) => angleScale(d.value));

    const g = svg.append("g");

    g.selectAll("path")
      .data(sortedGDP)
      .enter()
      .append("path")
      .attr("d", arc as any)
      .attr("fill", (d: any, i: any) => color(i))
      .attr("stroke", "#FFF")
      .attr("stroke-width", "1px")
      .on("mouseenter", function(this: any) {
        d3.select(this)
          .transition()
          .duration(200)
          .attr("opacity", 0.5);
      })
      .on("mouseout", function(this: any) {
        d3.select(this)
          .transition()
          .duration(200)
          .attr("opacity", 1);
      });

    g.selectAll("text")
      .data(this.data)
      .enter()
      .append("text")
      .text((d: any) => `${d.country} -  ${d.value} Trillion`)
      .attr("x", -150)
      .attr("dy", -8)
      .attr("y", (d: any, i: any) => -(i + 1) * 25);

    g.attr("transform", "translate(200,300)");
    (this.$refs.dst as any).appendChild(svg.node());
  }
}
</script>
