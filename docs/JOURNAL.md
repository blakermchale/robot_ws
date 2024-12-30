# 12/28/2024

- found that I was overriding self._clients in control_center.py consequently causing this error:

  ```
  AttributeError: 'str' object has no attribute 'handle'
  ```


