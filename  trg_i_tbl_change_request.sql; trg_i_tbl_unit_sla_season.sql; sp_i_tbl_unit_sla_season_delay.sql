<mxfile host="www.draw.io" modified="2020-02-14T21:20:49.407Z" agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36" etag="Qzs1Wvm_u0qhEJCzTpK1" version="12.7.0" type="github">
  <diagram id="APbCHEt9h7LmyBrYfhhx" name="Page-1">
    <mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="TYA-corCzER_tpGZpnsk-2" value="Business Process" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="20" y="20" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-3" value="Technical Process" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="20" y="100" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-4" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" vertex="1" parent="1">
          <mxGeometry x="40" y="180" width="30" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-5" value="Trigger" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="90" y="185" width="40" height="20" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-7" value="Borough User Submits SLA Change Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="80" y="270" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-8" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-7" target="TYA-corCzER_tpGZpnsk-9">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="20" y="400" as="sourcePoint"/>
            <mxPoint x="270" y="300" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-12" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-11">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="430" y="300"/>
              <mxPoint x="430" y="235"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-22">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-9" value="COO Focht Reviews Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="270" y="270" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-27" target="TYA-corCzER_tpGZpnsk-24">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-22" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record to tbl_change_request (which would include justification)&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" vertex="1" parent="1">
          <mxGeometry x="245" y="400" width="170" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-24" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;tbl_change_request_status with &lt;br&gt;- sla_change_status = 1 for &quot;submitted&quot;&lt;br&gt;- status_date equal to the current date and time&lt;br&gt;- status_user to the user that submitted the request&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" vertex="1" parent="1">
          <mxGeometry x="177.5" y="560" width="305" height="100" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-15" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-14">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="430" y="300"/>
              <mxPoint x="430" y="350"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-11" target="TYA-corCzER_tpGZpnsk-17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-11" value="Reject Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="480" y="205" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-17" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;&lt;b&gt;Insert:&lt;/b&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;new record into tbl_change_request_status with sla_change_status = 2 for &quot;approved&quot; or sla_change_status = 3 for &quot;rejected&quot;&lt;/span&gt;&lt;/div&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="690" y="260" width="230" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-14" target="TYA-corCzER_tpGZpnsk-17">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="680" y="350" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-14" value="Approve Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="480" y="320" width="120" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-21" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-17" target="TYA-corCzER_tpGZpnsk-17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-28" value="&lt;b&gt;trg_i_tbl_change_request.sql&lt;/b&gt;" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="120" y="505" width="180" height="20" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-27" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" vertex="1" parent="1">
          <mxGeometry x="315" y="500" width="30" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-22" target="TYA-corCzER_tpGZpnsk-27">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="330" y="480" as="sourcePoint"/>
            <mxPoint x="330" y="560" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
