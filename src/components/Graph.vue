<template>
  <div class="hello">
    <h1>Demo: {{ msg }}</h1>
    <pre>
# Data in the slot
{{ slotContentsParsed }}
    </pre>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";

@Component
export default class Graph extends Vue {
  @Prop() private msg!: string;
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

  get slotContentsParsed(): string {
    if (!this.slotContents) return "Empty slot";
    return this.slotContents
      .split("\n")
      .map((line, i) => `${i + 1}. ${line.trim()}`)
      .join("\n");
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
