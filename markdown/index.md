# About Go and Gosexy

[Go][1] is a (new) programming language full of **fresh ideas** that does not care about what your <span id="your-what">local Java guy</span> thinks is *right*.

[Gosexy][2] aims to be a set of **wrappers** and **libraries** that use make use of [Go][1]'s rich features to make everyday's coding even easier.

## Our goals

* Use [Go][1]'s **syntactic freedom** to achieve great code expressiveness.
* Wrap only the complex stuff, making Go code **simpler**.
* Learn what the **Go community** is doing and make use of great Open Source projects.

Got interested? please continue with our [getting started](/getting-started) page to learn more.

[1]: http://golang.org
[2]: http://gosexy.org

<script type="text/javascript">
  $(document).ready(
    function() {
      var choose = [
        'mom',
        'local Java guy',
        'president',
        'teacher'
      ];
      $('#your-what').text(choose[Math.floor(Math.random() * choose.length)]);
    }
  );
</script>
