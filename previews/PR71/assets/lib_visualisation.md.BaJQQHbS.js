import{_ as e,c as s,o as a,a7 as i}from"./chunks/framework.CICdM3gW.js";const b=JSON.parse('{"title":"Jet Visualisation Documentation","description":"","frontmatter":{},"headers":[],"relativePath":"lib/visualisation.md","filePath":"lib/visualisation.md","lastUpdated":null}'),t={name:"lib/visualisation.md"},n=i(`<h1 id="Jet-Visualisation-Documentation" tabindex="-1">Jet Visualisation Documentation <a class="header-anchor" href="#Jet-Visualisation-Documentation" aria-label="Permalink to &quot;Jet Visualisation Documentation {#Jet-Visualisation-Documentation}&quot;">​</a></h1><p>Documentation for visualisation interfaces extension module.</p><h2 id="index" tabindex="-1">Index <a class="header-anchor" href="#index" aria-label="Permalink to &quot;Index&quot;">​</a></h2><ul><li><a href="#JetReconstruction.animatereco-Tuple{ClusterSequence, Any}"><code>JetReconstruction.animatereco</code></a></li><li><a href="#JetReconstruction.jetsplot-Tuple{Any, ClusterSequence}"><code>JetReconstruction.jetsplot</code></a></li><li><a href="#JetReconstruction.jetsplot-Tuple{Any, Any}"><code>JetReconstruction.jetsplot</code></a></li></ul><h2 id="Jet-Visualisation-Public-Interfaces" tabindex="-1">Jet Visualisation Public Interfaces <a class="header-anchor" href="#Jet-Visualisation-Public-Interfaces" aria-label="Permalink to &quot;Jet Visualisation Public Interfaces {#Jet-Visualisation-Public-Interfaces}&quot;">​</a></h2><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="JetReconstruction.animatereco-Tuple{ClusterSequence, Any}" href="#JetReconstruction.animatereco-Tuple{ClusterSequence, Any}">#</a> <b><u>JetReconstruction.animatereco</u></b> — <i>Method</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">animatereco</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(cs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ClusterSequence</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, filename;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            barsize_phi </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0.1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            barsize_y </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0.1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            colormap </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> :glasbey_category10_n256</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            perspective </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0.5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            azimuth </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 2.7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            elevation </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0.5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            framerate </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            ancestors </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            Module </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Makie)</span></span></code></pre></div><p>Animate the jet reconstruction process and save it as a video file.</p><p><strong>Arguments</strong></p><ul><li><p><code>cs::ClusterSequence</code>: The cluster sequence object containing the jets.</p></li><li><p><code>filename</code>: The name of the output video file.</p></li></ul><p><strong>Optional Arguments</strong></p><ul><li><p><code>barsize_phi=0.1</code>: The size of the bars in the phi direction.</p></li><li><p><code>barsize_y=0.1</code>: The size of the bars in the y direction.</p></li><li><p><code>colormap=:glasbey_category10_n256</code>: The colormap to use for coloring the jets.</p></li><li><p><code>perspective=0.5</code>: The perspective of the plot.</p></li><li><p><code>azimuth=2.7</code>: The azimuth angle of the plot.</p></li><li><p><code>elevation=0.5</code>: The elevation angle of the plot.</p></li><li><p><code>framerate=5</code>: The framerate of the output video.</p></li><li><p><code>end_frames=0</code>: The number of static frames to show at the end of the animation. This can be useful to show the final state of the jets for a longer time.</p></li><li><p><code>title=nothing</code>: The title to add to the plot.</p></li><li><p><code>ancestors=false</code>: Whether to include ancestors of the jets in the animation. When <code>true</code> the ancestors of the jets will be plotted as well, as height zero bars, with the same colour as the jet they are ancestors of.</p></li><li><p><code>Module</code>: The plotting module to use. Default is <code>Makie</code>.</p></li></ul><p>For <code>perspective</code>, <code>azimuth</code>, and <code>elevation</code>, a single value can be passed for a fixed viewpoint, or a tuple of two values for a changing viewpoint. The viewpoint will then change linearly between the two values over the course of the animation.</p><p><strong>Returns</strong></p><ul><li><code>fig</code>: The figure object representing the final frame.</li></ul><p><a href="https://github.com/JuliaHEP/JetReconstruction.jl/blob/dd569669d41549cf9d6c18ea24c921ec118bb4d5/ext/JetVisualisation.jl#L157-L201" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="JetReconstruction.jetsplot-Tuple{Any, Any}" href="#JetReconstruction.jetsplot-Tuple{Any, Any}">#</a> <b><u>JetReconstruction.jetsplot</u></b> — <i>Method</i>. <p><code>jetsplot(objects, idx_arrays; barsize_phi=0.1, barsize_eta=0.1, colormap=:glasbey_hv_n256, Module=Main)</code></p><p>Plots a 3d bar chart that represents jets. Takes an <code>objects</code> array of objects to display and <code>idx_arrays</code>, an array of arrays with indeces, where <code>idx_arrays[i]</code> gives indeces of <code>objects</code> that form the jet number <code>i</code>. This function&#39;s signature might not be the most practical for the current version of the JetReconstruction.jl package, as it has been written during the early stage of development. There is now an overload of it that takes a <code>ClusterSequence</code> object as its argument.</p><p>Optional arguments: <code>barsize_phi::Real</code> — width of a bar along the ϕ axis; <code>barsize_eta::Real</code> — width of a bar along the η axis; <code>colormap::Symbol</code> — Makie colour map; <code>Module</code> — the module where you have your Makie (see below);</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span># example</span></span>
<span class="line"><span>using CairoMakie # use any other Makie that you have here</span></span>
<span class="line"><span></span></span>
<span class="line"><span>jetsplot([object1, object2, object3], [[1], [2, 3]])</span></span></code></pre></div><p>The example above plots <code>object1</code> as a separate jet in one colour and <code>object2</code> and <code>object3</code> together in another colour.</p><p>This function needs <code>Makie.jl</code> to work. You should install and import/use a specific backend yourself. <code>jetsplot</code> works with <code>CairoMakie</code>, <code>WGLMakie</code>, <code>GLMakie</code>, etc. Additionally, you can specify the module where you have your <code>Makie</code> explicitly:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>import CairoMakie</span></span>
<span class="line"><span>jetsplot(my_objects, my_colour_arrays, Module=CairoMakie)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>import GLMakie</span></span>
<span class="line"><span>jetsplot(my_objects, my_colour_arrays, Module=GLMakie)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>using WGLMakie</span></span>
<span class="line"><span>jetsplot(my_objects, my_colour_arrays, Module=Main) #default</span></span></code></pre></div><p><a href="https://github.com/JuliaHEP/JetReconstruction.jl/blob/dd569669d41549cf9d6c18ea24c921ec118bb4d5/ext/JetVisualisation.jl#L51-L80" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="JetReconstruction.jetsplot-Tuple{Any, ClusterSequence}" href="#JetReconstruction.jetsplot-Tuple{Any, ClusterSequence}">#</a> <b><u>JetReconstruction.jetsplot</u></b> — <i>Method</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">jetsplot</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(objects, cs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ClusterSequence</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; barsize_phi</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0.1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, barsize_eta</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0.1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, colormap</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">:glasbey_hv_n256</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, Module</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Main)</span></span></code></pre></div><p>Plots a 3d bar chart that represents jets. Takes <code>objects</code>, an array of objects to display (should be the same array you have passed to <code>jet_reconstruct</code> to get the <code>cs::ClusterSequence</code>), and the <code>cs::ClusterSequence</code> itself as arguments.</p><p>Optional arguments: <code>barsize_phi::Real</code> — width of a bar along the ϕ axis; <code>barsize_eta::Real</code> — width of a bar along the η axis; <code>colormap::Symbol</code> — Makie colour map; <code>Module</code> — the module where you have your Makie (see below);</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span># example</span></span>
<span class="line"><span>using CairoMakie # use any other Makie that you have here</span></span>
<span class="line"><span>jetsplot([object1, object2, object3], cluster_sequence_I_got_from_jet_reconstruct; Module=CairoMakie)</span></span></code></pre></div><p>This function needs <code>Makie.jl</code> to work. You should install and import/use a specific backend yourself. <code>jetsplot</code> works with <code>CairoMakie</code>, <code>WGLMakie</code>, <code>GLMakie</code>, etc. Additionally, you can specify the module where you have your <code>Makie</code> explicitly:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>import CairoMakie</span></span>
<span class="line"><span>jetsplot(my_objects, cs, Module=CairoMakie)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>import GLMakie</span></span>
<span class="line"><span>jetsplot(my_objects, cs, Module=GLMakie)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>using WGLMakie</span></span>
<span class="line"><span>jetsplot(my_objects, cs, Module=Main) #default</span></span></code></pre></div><p><a href="https://github.com/JuliaHEP/JetReconstruction.jl/blob/dd569669d41549cf9d6c18ea24c921ec118bb4d5/ext/JetVisualisation.jl#L11-L38" target="_blank" rel="noreferrer">source</a></p></div><br>`,11),o=[n];function l(p,c,r,h,d,u){return a(),s("div",null,o)}const g=e(t,[["render",l]]);export{b as __pageData,g as default};
