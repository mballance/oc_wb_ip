<coverage version="2012.1">
  <graph>wb_dma_infact_4par_seq.aut</graph>
  <functional-coverage enabled="false" attach-monitor="true"/>
  <distribute>true</distribute>
  <path-coverage name="ll_size" enable-functional-coverage="true">
    <start-action name="do_4par"/>
    <bin-scheme name="ll_desc_sizes"/>
    <cross-coverage type="include">
      <meta-action name="t1.ll_desc_sz"/>
      <meta-action name="t2.ll_desc_sz"/>
      <meta-action name="t3.ll_desc_sz"/>
      <meta-action name="t4.ll_desc_sz"/>
    </cross-coverage>
  </path-coverage>
</coverage>
