<!DOCTYPE html>
<html lang="en">

  <head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <link href="//fonts.googleapis.com/css?family=PT+Serif" rel="stylesheet" type="text/css">
    <link href="//fonts.googleapis.com/css?family=PT+Sans" rel="stylesheet" type="text/css">
    <link href="//fonts.googleapis.com/css?family=Source+Code+Pro" rel="stylesheet" type="text/css">

    <meta name="go-import" content="menteslibres.net/gosexy/db git https://github.com/gosexy/db">
    <meta name="go-import" content="menteslibres.net/gosexy/canvas git https://github.com/gosexy/canvas">
    <meta name="go-import" content="menteslibres.net/gosexy/checksum git https://github.com/gosexy/checksum">
    <meta name="go-import" content="menteslibres.net/gosexy/yaml git https://github.com/gosexy/yaml">
    <meta name="go-import" content="menteslibres.net/gosexy/rest git https://github.com/gosexy/rest">
    <meta name="go-import" content="menteslibres.net/gosexy/redis git https://github.com/gosexy/redis">
    <meta name="go-import" content="menteslibres.net/gosexy/dig git https://github.com/gosexy/dig">
    <meta name="go-import" content="menteslibres.net/gosexy/to git https://github.com/gosexy/to">
    <meta name="go-import" content="menteslibres.net/gosexy/cli git https://github.com/gosexy/cli">

    {{ if .IsHome }}
        <title>{{ setting "page/head/title" }}</title>
    {{ else }}
      {{ if .Title }}
        <title>
          {{ .Title }} {{ if setting "page/head/title" }} // {{ setting "page/head/title" }} {{ end }}</title>
      {{ else }}
        <title>{{ setting "page/head/title" }}</title>
      {{ end }}
    {{ end }}

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <link rel="stylesheet" href="//menteslibres.net/static/normalize/normalize.css" />

    <link rel="stylesheet" href="//menteslibres.net/static/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="//menteslibres.net/static/bootstrap/css/bootstrap-responsive.css" />

    <link rel="stylesheet" href="//menteslibres.net/static/highlightjs/styles/solarized_dark.css">
    <script src="//menteslibres.net/static/highlightjs/highlight.pack.js"></script>

    <link rel="stylesheet" href="{{ asset "/styles.css" }}" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script type="text/javascript">
      $(document.body).ready(
        function() {
          // Code (marking code blocks for prettyPrint)
          var code = $('code');

          for (var i = 0; i < code.length; i++) {
            var el = $(code[i])
            var className = el.attr('class');
            if (className) {
              el.addClass('language-'+className);
            }
          };

          /*
          // An exception, LaTeX blocks.
          var code = $('code.latex');

          for (var i = 0; i < code.length; i++) {
            var el = $(code[i])
            var img = $('<img>', { 'src': 'http://phibin.com/api/render?snippet='+encodeURIComponent(el.html()) });
            img.insertBefore(el);
            el.hide();
          };
          */

          // Starting prettyPrint.
          hljs.initHighlightingOnLoad();

          // Tables without class

          $('table').each(
            function(i, el) {
              if (!$(el).attr('class')) {
                $(el).addClass('table');
              };
            }
          );

          // Navigation
          var links = $('ul.menu li').removeClass('active');

          for (var i = 0; i < links.length; i++) {
            var a = $(links[i]).find('a');
            if (a.attr('href') == document.location.pathname) {
              $(links[i]).addClass('active');
            };
          };

        }
      );
    </script>

    <style type="text/css">
      .navbar .brand {
        margin-left: 0px;
      }
      body {
        padding-top: 50px;
      }
    </style>

  </head>

  <body>

    <div class="container" id="container">
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">

          <a class="brand" href="{{ asset "/" }}">{{ setting "page/brand" }}</a>

          <div class="nav-collapse">
            {{ if settings "page/body/menu" }}
              <ul id="nav" class="nav menu">
                {{ range settings "page/body/menu" }}
                  <li>{{ link .url .text }}</li>
                {{ end }}
              </ul>
            {{ end }}
            {{ if settings "page/body/menu_pull" }}
              <ul id="nav" class="nav pull-right menu">
                {{ range settings "page/body/menu_pull" }}
                  <li>{{ link .url .text }}</li>
                {{ end }}
              </ul>
            {{ end }}
          </div>

        </div>
      </div>
    </div>


    {{ if .IsHome }}

      <div class="hero-unit">
        <img src="{{ asset "/images/gophers.png" }}" />
        <h1>menteslibres.net/gosexy</h1>
        <p>
          Libraries and wrappers for the <a href="http://golang.org" target="_blank">Go</a> learner.
        </p>
        <p class="pull-right">
          <a href="{{ asset "/getting-started" }}" class="btn btn-primary btn-large">
            Get started
          </a>
        </p>
      </div>

      <div class="container-fluid">
        <div class="row">
          <div class="span11">
            {{ .ContentHeader }}

            {{ .Content }}

            {{ .ContentFooter }}
          </div>
        </div>
      </div>

    {{ else }}

      {{ if .BreadCrumb }}
        <ul class="breadcrumb menu">
          {{ range .BreadCrumb }}
            <li><a href="{{ url .link }}">{{ .text }}</a> <span class="divider">/</span></li>
          {{ end }}
        </ul>
      {{ end }}

      <div class="container-fluid">

        <div class="row">
          {{ if .SideMenu }}
            {{ if .Content }}
              <div class="span3">
                  <ul class="nav nav-list menu">
                    {{ range .SideMenu }}
                      <li>
                        <a href="{{ url .link }}">{{ .text }}</a>
                      </li>
                    {{ end }}
                  </ul>
              </div>
              <div class="span8">
                {{ .ContentHeader }}

                {{ .Content }}

                {{ .ContentFooter }}
              </div>
            {{ else }}
              <div class="span11">
                {{ if .CurrentPage }}
                  <h1>{{ .CurrentPage.text }}</h1>
                {{ end }}
                <ul class="nav nav-list menu">
                  {{ range .SideMenu }}
                    <li>
                      <a href="{{ url .link }}">{{ .text }}</a>
                    </li>
                  {{ end }}
                </ul>
              </div>
            {{ end }}
          {{ else }}
            <div class="span11">
              {{ .ContentHeader }}

              {{ .Content }}

              {{ .ContentFooter }}
            </div>
          {{ end }}
        </div>

      </div>

    {{ end }}

    <hr />

    <footer>
      Powered by <a href="http://luminos.menteslibres.org" target="_blank">luminos</a>. Wanna <a href="https://github.com/gosexy/gosexy.org">hack</a> this site?
    </footer>

    {{ if setting "page/body/scripts/footer" }}
      <script type="text/javascript">
        {{ setting "page/body/scripts/footer" | jstext }}
      </script>
    {{ end }}

  </body>
</html>
