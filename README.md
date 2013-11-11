Redmine due_subtask
===================

Very simple redmine plugin for our very own specific use case of needing a calculated custom field.

This plugin is not intended for general use yet, it lacks a proper configuration
screen and tests.

After saving any issue, the plugin will update a calculated field called 'Due subtask' with the
minimum value of the 'due date' field among all the issue's subtaks (or its own 'due date' if
no open subtasks).

Must be installed in `plugins/due_subtask`
