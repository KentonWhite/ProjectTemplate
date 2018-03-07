---
layout: page
---
## Custom templates
Although ProjectTemplate favours convention over configuration, it is possible to create custom templates that deviate
from the [standard templates](./architecture.html). It should probably not be the first thing you experiment with, but
the process is pretty easy.

### Configure custom template directory
First of all you need a location to store your custom template(s). To make it easier to refer to this location,
ProjectTemplate supports an `option` to look for, and store, templates. To set this option use the following code:

    > options(ProjectTemplate.templatedir = "/path/to/your/templates")

It is useful to store this in a `.Rprofile` file that is loaded automatically when an R session starts.

### Create a custom template
To create a template you can use the `create.template` function which takes two arguments:

 * **target**: Either the name or the full path to a new directory in which the template will be stored.
   The name of this directory will be the name of the template.
 * **source**: A template on which the new template will be based.
   It defaults to the `minimal` template supplied with ProjectTemplate.

When only the template name is specified the new template will be created in the template directory. If the template
directory is not configured the template will be created in the current directory.

### Create a project from a custom template
When calling `create.project` it is possible to specify the `template` argument. The name specified is first lookup in
the template directory, then in the default installed templates, and finally in the current directory.

### Update a custom template
As a template essentially is just like any project directory the normal `migrate.project` function could be used to
update the template with the latest changes from the package. However, as a convenience, a function `migrate.template`
was created that does this for you by simply calling it with the template name. For example to upgrade a template called
`default`, you would call `migrate.template('default')`.
