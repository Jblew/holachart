<template>
  <div id="app">
    <Graph>
      [{"country":"USA","value":20.5},{"country":"China","value":13.4},{"country":"Germany","value":4},{"country":"Japan","value":4.9},{"country":"France","value":2.8}]
    </Graph>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Graph from "./components/Graph.vue";

@Component({
  components: {
    Graph,
  },
})
export default class App extends Vue {}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
