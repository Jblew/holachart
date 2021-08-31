<template>
  <div id="app">
    <Graph msg="Welcome to Your Vue.js + TypeScript App">
      console.log('Code in the slot');
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
