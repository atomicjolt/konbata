## Issues:
- If a docx file has fields, data is sometimes lost from those fields.

- You can’t name files the same thing even if they're in separate modules. There will be name collisions. Or maybe you can’t name module items the same thing. All the files will end up in the file tree, but there will be missing module items. Right now, we're appending “(Vol. <volume>)” to every filename to fix the problem. There's probably a better way though.

- We don't handle errors resulting from an incomplete or badly formed konbata.yml file.

- If you place a file in the top level of the “sources” directory, Konbata will throw an error.

## Notes:

#### General

- There's a good chance we'll end up needing to convert PDF files along with word doc files. This library looked like it might be a good option: Kristin - https://github.com/ricn/kristin.

#### File Types:

Types of Files (and data chunks extracted therefrom):
- FrontFile (has "front" in the name)
    - Course info
    - Preface
    - Tables of Contents
- GlossaryFile (has "glos" in the name)
    - Glossary
- UnitFile (has "U#" in the name, looks like "U1", "U2", etc.)
    - Lesson material
    - Self-test quizzes
    - Unit review exercises.

(Ignore Back files. They’re useless.)

#### Parsing Unit Files (based on HTML conversion by LibreOffice)

All content should be put into a page except the quizzes (self-test questions (one per major unit section) and the unit review exercises (one per unit)).

##### To identify self-test question sets:
  - Look for “Self-Test Questions” header. It’s actually just in a `<p>` tag.
  - After the header, there’s a “After you complete these questions, you may check your answers…” line.
  - There are sections within the self-test questions. They are designated by a minor section number followed by a period followed by the minor section name. e.g. “201. The layout of an area”
  - Within each section, there are a number of questions. These are designed by a question number (should start with 1 since the numbers starts over for every section in the self-test questions) followed by a period followed by the question text. e.g. “1. What is the first step in laying out a small construction area?”

##### To identify answers to self-test questions:
  - Look for “Answers to Self-Test Questions” header. It’s in a `<p>` tag.
  - Answers are divided up into sections. The section is designated by a number that matches the minor section number from the document that the questions correlate to. Nothing follows this number in the line.
  - Questions following the section header are indicated by a number (should start with 1) followed by a period followed by the answer text.
  - After the answers are finished, there is a “Do the unit review exercises before going to the next unit.”

##### To identify unit review exercises:
  - Look for “Unit Review Exercises” header. It’s in a `<p>` tag.
  - After the header, there is a “Note to Students: …” line.
  - After that, there is a “Do not return your answer sheet to AFCDA.” line.
  - After that, you have all the questions.
  - Each question is designed by a number (should start with 1) followed by a period followed by the question text.
  - Each question has a set of answers. Each answer is designed by a single lowercase letter (should start with “a”) followed by a period followed by the answer text.
  - After the questions, there’s a “Please read the unit menu…” line.
