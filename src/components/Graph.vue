<template>
  <div class="graph">
    The graph:
    <CirclePack v-if="jsonData" :data="jsonData" />
    <span v-else>Data for holachart-graph missing or invalid JSON</span>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import CirclePack from "@/circle-pack/CirclePack.vue";

@Component({
  components: {
    CirclePack,
  },
})
export default class Graph extends Vue {
  private slotContents = "";

  mounted(): void {
    this._populateSlotContents();
  }

  _populateSlotContents(): void {
    const defaultSlot = this.$slots.default;
    if (defaultSlot) {
      const text = defaultSlot[0].text;
      if (text && text.length > 0) {
        this.slotContents = text;
        return;
      }
    }
    setTimeout(() => this._populateSlotContents(), 25);
  }

  get jsonData(): unknown | undefined {
    if (!this.slotContents) return undefined;
    return JSON.parse(this.slotContents.trim());
  }
}
</script>
<style scoped>
h1 {
  color: purple;
}
pre {
  margin: 1rem;
  text-align: left;
  background: #ddd;
  font-family: monospace;
  padding: 1rem;
  text-align: left;
}
</style>
