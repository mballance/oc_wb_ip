<coverage version="2012.1">
  <graph>wb_dma_pss_parallel_xfer_seq.aut</graph>
  <functional-coverage enabled="false" attach-monitor="true"/>
  <distribute>true</distribute>
  <path-coverage name="all_inc_dec_1_2" enable-functional-coverage="true">
    <start-action name="xfers.xfers"/>
    <cross-coverage type="include">
      <meta-action name="xfers.xfers[0].inc_dst"/>
      <meta-action name="xfers.xfers[0].inc_src"/>
      <meta-action name="xfers.xfers[1].inc_dst"/>
      <meta-action name="xfers.xfers[1].inc_src"/>
    </cross-coverage>
  </path-coverage>
  <path-coverage name="all_inc_dec_3_4" enable-functional-coverage="true">
    <start-action name="xfers.xfers"/>
    <cross-coverage type="include">
      <meta-action name="xfers.xfers[2].inc_dst"/>
      <meta-action name="xfers.xfers[2].inc_src"/>
      <meta-action name="xfers.xfers[3].inc_dst"/>
      <meta-action name="xfers.xfers[3].inc_src"/>
    </cross-coverage>
  </path-coverage>
</coverage>
