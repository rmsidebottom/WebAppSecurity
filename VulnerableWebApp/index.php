<!DOCTYPE html>
<html lang="en">

    <head>
      <title>SQL Injection Tester</title>
  </head>

    <body>
        <form action = "submit.php" method = "post">
           <p>Sign the book and add a note!</p>
           <p>Name: <input type = "text" name = "signee" /></p>
           <p>Note: <input type = "text" name = "note" /></p>
           <p><input type = "submit" value = "submit" /></p>
        </form>


        <form action = "search.php" method = "post">
            <p>Search for your entries:</p>
            <p><input type = "text" name = "search" /></p>
            <p><input type = "submit" value = "submit" /></p>
         </form>
    </body>

</html>